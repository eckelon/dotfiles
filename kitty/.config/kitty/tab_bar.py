# pyright: reportMissingImports=false
from datetime import datetime
from getpass import getuser
from socket import gethostname

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.tab_bar import (DrawData, ExtraData, Formatter, TabBarData, as_rgb,
                           draw_attributed_string, draw_title)
from kitty.utils import color_as_int

opts = get_options()
icon_fg = as_rgb(color_as_int(opts.color16))
icon_bg = as_rgb(color_as_int(opts.color8))
bat_text_color = as_rgb(color_as_int(opts.color15))
clock_color = as_rgb(color_as_int(opts.color15))
date_color = as_rgb(color_as_int(opts.color8))
SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")
RIGHT_SEPARATOR_SYMBOL = "\ue0ba"
RIGHT_MARGIN = 0
REFRESH_TIME = 1
ICON = " 💻  "

background_color = as_rgb(color_as_int(opts.background))
even_color_bg = as_rgb(color_as_int(opts.color4))
odd_color_bg = as_rgb(color_as_int(opts.color15))
cell_fg = as_rgb(color_as_int(opts.background))



def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return 0
    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = icon_fg
    screen.cursor.bg = icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.cursor.x = len(ICON)
    return screen.cursor.x


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    if screen.cursor.x <= len(ICON):
        screen.cursor.x = len(ICON)
    screen.draw(" ")
    screen.cursor.bg = tab_bg
    draw_title(draw_data, screen, tab, index)
    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
        screen.cursor.fg = prev_fg
    end = screen.cursor.x
    return end


def _draw_right_status(screen: Screen, is_last: bool, cells: list) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)
    screen.cursor.x = screen.columns - right_status_length
    screen.cursor.fg = 0
    cell_index = 0
    for color, status in cells:
        cell_index += 1
        screen.cursor.fg = even_color_bg if cell_index % 2 == 0 else odd_color_bg
        screen.cursor.bg = background_color if cell_index == 1 else screen.cursor.bg
        screen.draw(RIGHT_SEPARATOR_SYMBOL)
        screen.cursor.bg = even_color_bg if cell_index % 2 == 0 else odd_color_bg
        screen.cursor.fg = cell_fg
        screen.draw(status)
    screen.cursor.bg = 0
    return screen.cursor.x


def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()

timer_id = None
right_status_length = -1

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    global right_status_length
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
    clock = datetime.now().strftime(" %H:%M ")
    date = datetime.now().strftime(" %d.%m.%Y ")
    username = getuser()
    hostname = gethostname().replace('.local', '')
    cells = []
    cells.append((clock_color, clock))
    cells.append((date_color, date))
    cells.append((date_color, f' {username} @ {hostname} '))

    right_status_length = RIGHT_MARGIN
    for cell in cells:
        cell_length = len(str(cell[1])) + 1
        right_status_length += cell_length

    _draw_icon(screen, index)
    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    _draw_right_status(
        screen,
        is_last,
        cells,
    )
    return screen.cursor.x
