class main.flvLoader extends MovieClip {
	var owner
	var netConn1
	//
	function flvLoader(myUrl, trgt, trgtNS, nameNS, myBufferTime, server) {
		trgt.attachMovie("video", "video", trgt.getNextHighestDepth());
		netConn1 = new NetConnection();
		netConn1.connect(server);
		trgtNS[nameNS] = new NetStream(netConn1);
		trgtNS[nameNS].owner = trgtNS;
		trgtNS[nameNS]["onMetaData"] = function (obj:Object) {
			//
			//this.setBufferTime(obj.duration);
			//this.setBufferTime(5)
			owner.myDuration = obj.duration;
		};
		trgtNS[nameNS].onStatus = function(infoObject) {
			trace(infoObject.code)
			if (infoObject.code == "NetStream.Buffer.Full") {
				if (owner.d == 0) {
					owner.d = setInterval(owner, "indice_flv", 30);
					owner.myToolbar.contr.gotoAndStop(2);
					owner.play_status = true;
					if (owner.firstTime) {
						owner.stopper = setInterval(owner, "stoppa", 500);
						owner.loadedMov = owner.currMov;
					}
					/**/
				}
				owner.resizza(owner.monitor.video.vid_flv);
				owner.myToolbar.lab = this.tit+": Buffer Full";
			}
			if (infoObject.code == "NetStream.Play.Stop") {
				this.seek(0)
			}
		};
		trgtNS[nameNS].setBufferTime(trgtNS.myDuration/10);
		trgt.video.vid_flv.attachVideo(trgtNS[nameNS]);
		trgt.video.vid_flv._parent.attachAudio(trgtNS[nameNS]);
		trgtNS[nameNS].play(myUrl);
	}
}
