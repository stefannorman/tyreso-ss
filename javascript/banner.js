var images = new Array (
	'/images/banner1.jpg',
	'/images/banner2.jpg',
	'/images/banner3.jpg',
	'/images/banner4.jpg',
	'/images/banner5.jpg',
	'/images/banner6.jpg',
	'/images/banner7.jpg'
);
var banner;
var imageNo;
function switchBanner() {
	// fade out
	for (var i=0;i<10;i++)
		setTimeout('setOpacity('+(10-i)+')', 100*i);

	setTimeout('changeBanner()', 100*10);

	// fade in	
	for (var i=13;i<=22;i++)
		setTimeout('setOpacity('+(i-12)+')', 100*i);
}

function changeBanner(){
	imageNo++;
	if(imageNo == images.length)
		imageNo = 0;
	banner.src = images[imageNo];
}

function setOpacity(value)
{
	banner.style.opacity = value/10;
	banner.style.filter = 'alpha(opacity=' + value*10 + ')';
}

function showBanner() {
	banner = document.getElementById('banner');
	imageNo = Math.round(Math.random()*(images.length-1));
	banner.src = images[imageNo];
	banner.style.visibility = 'visible';

	setInterval(switchBanner, 10000);
}

