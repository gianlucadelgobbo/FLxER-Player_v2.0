class main.mcLoader extends MovieClip {
	function mcLoader(myUrl, trgt, trgtF, fnzInit, fnzProg) {
		trgt.myMcl = new MovieClipLoader();
		trgt.createEmptyMovieClip("trgta", _root.getNextHighestDepth());
		trgt["trgta"]._lockroot = true;
		trgt.myListener = new Object();
		if (fnzProg) {
			trgt.myListener.onLoadProgress = function(target_mc, loadedBytes, totalBytes) {
				trgtF[fnzProg](target_mc, loadedBytes, totalBytes);
			};
		}
		trgt.myListener.onLoadInit = function(target_mc) {
			trgtF[fnzInit](target_mc);
		};
		trgt.myMcl.addListener(trgt.myListener);
		trgt.myMcl.loadClip(myUrl, trgt["trgta"]);
	}
}
