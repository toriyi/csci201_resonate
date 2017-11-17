<%@ include file="includes/global_header.jsp" %>
<%
/*if (u == null) {
	response.sendRedirect("/Resonate/login.jsp");
} 
if (p == null) {
	response.sendRedirect("/Resonate/myprojects.jsp");
}*/
%>
<div id="hideDiv"></div>
<div id="track_0" class="snapTrack">
	<div style="float:left">
		Track Title<br />
		Creator: isaac<br />
	</div>
	<div style="float:right;">
		00:00:00<br />
		Votes
	</div>
</div>
<div id="track_1" class="snapTrack">
	<div style="float:left">
		Track Title 2<br />
		Creator: git god<br />
	</div>
	<div style="float:right;">
		00:00:00<br />
		Votes
	</div>
</div>
<div id="track_2" class="snapTrack">
	<div style="float:left">
		Solo<br />
		Creator: git god<br />
	</div>
	<div style="float:right;">
		00:00:00<br />
		Votes
	</div>
</div>
<audio id="audio_0" src="uploads/project1/project1_audio1_guitar1.mp3" preload="auto"></audio>
<audio id="audio_1" src="uploads/project1/project1_audio2_bass1.mp3" preload="auto"></audio>
<audio id="audio_2" src="uploads/project1/project1_audio3_guitar2.mp3" preload="auto"></audio>
<table style="width:100%; height:100%; overflow-x: scroll;">
	<tr style="width:100%; height:625px;">
		<td style="width: 320px; padding: 0px 7px 0px 7px;">
		<div class="title" style="width:306px;">Tracks</div>
		<div style="width:306px; height: 590px;">
			&nbsp;
		</div>
		</td>
		<td style="width:75%; background: #f0f0f0; border-left:#979797 2px solid;">
		<div class="title" style="width: 100%; margin-left: 5px; padding-left:2px;">Stage</div>
		<div style="width: 10px; height: 495px; float:left;">
				<br /><br />1
				<br /><br /><br />2
				<br /><br /><br />3
				<br /><br /><br />4
				<br /><br /><br />5
				<br /><br /><br />6
			</div>
			<div id="scroller">
				<div id="stage" style="width:8000px; height: 495px;">
				</div>		
			</div>
			<div style="width:100%; height: 80px; float:left;">
				<div style="width: 210px;margin:auto;">
					<div id="playBtn"><div id="playTriangle"></div></div>
					<div id="stopBtn"><div id="stopSquare"></div></div>
				</div>
			</div>
		</td>
	</tr>
</table>

<script type="text/javascript">

// TODO: Potentially waveforms, if there's time.
// https://www.npmjs.com/package/waveform-data

var tracksin = 0;
var scrolloffset = 0;
var playhead = 0;
var playing = false;

$(function() {
	$('.snapTrack').each(function(index) {
		var audio = document.getElementById("audio_" + index.toString());
		var aWidth = 25*(audio.duration);
		$(audio).data('tOffset', 0);
		audio.loop = false;
		
		var element = document.getElementById('track_' + index.toString());
		
		var x = 0, y = 0;
		var box = (120 + 72*index).toString() + "px";

		$(element).css('top', box);
		$(element).data('xVal', null);
		$(element).data('yVal', null);
		
		var dragobj = interact(element);
		dragobj.draggable({
			snap: {
				targets: [interact.createSnapGrid({ x: 10, y: 64 })],
				range: Infinity,
				relativePoints: [ { x: 0, y: 0 } ]
			},
			inertia: true,
			restrict: {
				restriction: document.getElementById('stage'),
				elementRect: { top: 0, left: 0, bottom: 1, right: 1 },
				endOnly: true
			}
		})
		.on('dragmove', function (event) {
			x += event.dx;
			$(element).data('xVal', x);
			$(element).data('yVal', y);
			//console.log($(element).data('xVal'));
			
			event.target.style.webkitTransform =
			event.target.style.transform =
			    'translate(' + x + 'px, ' + y + 'px)';
			
	
			var ofs = $(audio).data('tOffset');
			$(audio).data('tOffset', ofs + (0.01*event.dx));
			console.log($(audio).data('tOffset'));
			if (playhead == 0) audio.currentTime = 0;
			else audio.currentTime = (playhead-$(audio).data('tOffset'));
		}).draggable(false);
	  	
		dragobj.on('doubletap', function (event) {
			if (playhead == 0) audio.currentTime = 0;
			else audio.currentTime = (playhead-$(audio).data('tOffset'));
			
			if (x == 0 && y == 0) {
				x = 333; y = 22 + 72*(tracksin-(index));
				$(element).data('xVal', x);
				$(element).data('yVal', y);
				  element.style.webkitTransform =
					    element.style.transform =
					        'translate(' + (333 - scrolloffset) + 'px, ' + y + 'px)';
				  $(element).css('width', aWidth);
				  $(element).css('z-index', 5);
				  $(element).css('background', '#ffffff url(images/waveform' + index%3 + '.PNG) repeat-x left bottom');
				  tracksin++;
				  dragobj.draggable(true);
		
			  } else {
				if (!audio.paused) audio.pause();
			  	element.style.webkitTransform =
				    element.style.transform =
				        'translate(0px, 0px)';
			  	x=y=0;
			  	$(element).data('xVal', null);
				$(element).data('yVal', null);
				$(audio).data('tOffset', 0);
			  	dragobj.draggable(false);
			  	$(element).css('width', 306);
			  	$(element).css('background', 'none');
			  	$(element).css('z-index', 15);
			  	tracksin--;
			  }
	  	});
	});
	
	$('#scroller').scrollLeft(0);

	$('#scroller').scroll(function() {
		scrolloffset = $('#scroller').scrollLeft();
		$('.snapTrack').each(function(index) {
			var element = document.getElementById('track_' + index.toString());
			var x = $(element).data('xVal') - scrolloffset;
			var y = $(element).data('yVal');
			//y += event.dy; TODO
			
			element.style.webkitTransform =
			element.style.transform =
			    'translate(' + x + 'px, ' + y + 'px)';
		});
	});
	
	$("#playBtn").click(function() {
		$('.snapTrack').each(function(index) {
			var element = document.getElementById("track_" + index.toString());
			var audio = document.getElementById("audio_" + index.toString());
			
			if (!playing) {
				if ($(element).data('xVal') != null) {
					if (audio.ended) {
						audio.currentTime = 0;
					}
				}
			} else {
				audio.pause();
			}
		});
		if (!playing) playing = true;
		else playing = false;
	});
	
	$("#stopBtn").click(function() {
		$('.snapTrack').each(function(index) {
			var element = document.getElementById("track_" + index.toString());
			var audio = document.getElementById("audio_" + index.toString());
			
			audio.pause();
			audio.currentTime = 0;
		});
		playing = false;
		playhead = 0;
	});
});
var d = new Date();
var prevTime = d.getTime();
var currTime;
setInterval(function () {
	d = new Date();
	currTime = d.getTime();
	
	var addTime = currTime-prevTime;
	if (playing) {
		playhead += addTime/1000;
		console.log(playhead);
		
		var anyplays = false;

		$('.snapTrack').each(function(index) {
			var element = document.getElementById("track_" + index.toString());
			var audio = document.getElementById("audio_" + index.toString());
			if (!audio.playing && $(element).data('xVal') != null) {
				anyplays = true;
				var cOffset = $(audio).data('tOffset');
				if (playhead >= cOffset && playhead < (cOffset + audio.duration)) {
					audio.play();
				}
			}
		});
		
		if (!anyplays) {
			playhead = 0;
			playing = false;
		} else anyplays = false;
	}
	
	d = new Date();
	prevTime = d.getTime();
}, 300);

</script>
<%@ include file="includes/global_footer.jsp" %>