package local.expand;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;
import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.ui.IPackagesViewPart;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.preference.PreferenceConverter;
import org.eclipse.jface.resource.JFaceResources;
import org.eclipse.jface.viewers.ITreeContentProvider;
import org.eclipse.jface.viewers.TreeViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IStartup;
import org.eclipse.ui.IViewPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.osgi.framework.Bundle;

/** Install-wide tweaks: editor fonts (every workspace) and a fully expanded Package Explorer. */
public class ExpandStartup implements IStartup {
	private static final String VIEW_ID = "org.eclipse.jdt.ui.PackageExplorer";

	// Same typeface as Ghostty's font-family. SWT has no semibold style, so the Regular face is used.
	private static final FontData FONT = new FontData("JetBrainsMono Nerd Font Mono", 12, SWT.NONE);

	private static final String[] FONT_KEYS = {
			"org.eclipse.jface.textfont",
			"org.eclipse.jdt.ui.editors.textfont",
			"org.eclipse.jdt.ui.PropertiesFileEditor.textfont",
			"org.eclipse.debug.ui.consoleFont",
			"org.eclipse.debug.ui.DetailPaneFont",
			"org.eclipse.debug.ui.MemoryViewTableFont",
			"org.eclipse.ui.workbench.texteditor.blockSelectionModeFont",
			"org.eclipse.compare.contentmergeviewer.TextMergeViewer",
			"org.eclipse.jdt.internal.ui.compare.JavaMergeViewer",
			"org.eclipse.jdt.internal.ui.compare.PropertiesFileMergeViewer",
			"org.eclipse.egit.ui.CommitMessageEditorFont",
			"org.eclipse.egit.ui.CommitMessageFont",
			"org.eclipse.egit.ui.DiffHeadlineFont" };

	@Override
	public void earlyStartup() {
		// earlyStartup runs on a background job thread. Everything below touches SWT (the font
		// registry creates Device resources, preference listeners poke StyledText widgets), so it
		// all has to run on the UI thread.
		PlatformUI.getWorkbench().getDisplay().asyncExec(() -> {
			applyFonts();
			Display display = PlatformUI.getWorkbench().getDisplay();
			// Delay so the perspective finishes restoring; retry in case the tree was still empty.
			display.timerExec(3000, () -> expand(1));
			display.timerExec(8000, () -> expand(2));
		});
	}

	private static void applyFonts() {
		try {
			FontData[] fonts = { FONT };
			IPreferenceStore store = PlatformUI.getPreferenceStore();
			for (String key : FONT_KEYS) {
				PreferenceConverter.setValue(store, key, fonts);
			}
			// Registered fonts are cached by the registry; update it so already created viewers follow too.
			JFaceResources.getFontRegistry().put("org.eclipse.jface.textfont", fonts);
			log("fonts set to " + FONT);
		} catch (Throwable t) {
			log("font update failed: " + t);
		}
	}

	private static void expand(int attempt) {
		try {
			IWorkbenchWindow window = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
			if (window == null) {
				return;
			}
			IWorkbenchPage page = window.getActivePage();
			if (page == null) {
				return;
			}
			IViewPart view = page.findView(VIEW_ID);
			if (!(view instanceof IPackagesViewPart packagesView)) {
				log("[attempt " + attempt + "] Package Explorer not found (view=" + view + ")");
				return;
			}
			TreeViewer viewer = packagesView.getTreeViewer();
			if (viewer == null) {
				log("[attempt " + attempt + "] tree viewer is null");
				return;
			}
			expandContainers(viewer, viewer.getInput());
			log("[attempt " + attempt + "] expanded " + viewer.getExpandedElements().length + " nodes");
		} catch (Throwable t) {
			log("[attempt " + attempt + "] failed: " + t);
		}
	}

	/**
	 * Expands containers down to file level. Files are left collapsed on purpose: expanding a
	 * compilation unit would list its fields, methods and constructors.
	 */
	private static void expandContainers(TreeViewer viewer, Object input) {
		if (input == null || !(viewer.getContentProvider() instanceof ITreeContentProvider provider)) {
			return;
		}
		for (Object root : provider.getElements(input)) {
			expandContainer(viewer, provider, root);
		}
	}

	private static void expandContainer(TreeViewer viewer, ITreeContentProvider provider, Object element) {
		if (element instanceof IFile || element instanceof ICompilationUnit) {
			return;
		}
		if (!provider.hasChildren(element)) {
			return;
		}
		viewer.expandToLevel(element, 1);
		for (Object child : provider.getChildren(element)) {
			expandContainer(viewer, provider, child);
		}
	}

	private static void log(String message) {
		Bundle bundle = Platform.getBundle("local.expand");
		if (bundle != null) {
			Platform.getLog(bundle).log(new Status(IStatus.INFO, "local.expand", message));
		}
	}
}
