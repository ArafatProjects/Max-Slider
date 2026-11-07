package;

import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.events.MouseEvent;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

class BannerSlider extends Sprite {
    private var slides:Array<Dynamic>;
    private var currentIndex:Int = 0;
    private var imageLoader:Loader;
    private var bannerContainer:Sprite;
    private var timer:Timer;
    private var thumbContainer:Sprite;
    private var thumbs:Array<Sprite>;

    public function new() {
        super();

        // 1. Define your slides (Image path, optional link, and thumbnail preview path)
        slides = [
            { 
                image: "/images/slider-1.jpg", 
                thumb: "/images/slider-1.jpg", 
                link: "/videos/Contests/selfie-contests.html" 
            },
            { 
                image: "/images/slider-2.jpg", 
                thumb: "/images/slider-2.jpg", 
                link: "/games/Oggy/oggy-chase.html" 
            },
            { 
                image: "/images/slider-3.jpg", 
                thumb: "/images/slider-3.jpg", 
                link: "" // No link - will act as a static image only
            },
            { 
                image: "/images/slider-4.jpg", 
                thumb: "/images/slider-4.jpg", 
                link: "/shows/ninja-hattori.html" 
            }
        ];

        // 2. Main Clickable Banner Area Container
        bannerContainer = new Sprite();
        bannerContainer.buttonMode = true;
        bannerContainer.addEventListener(MouseEvent.CLICK, onBannerClick);
        addChild(bannerContainer);

        imageLoader = new Loader();
        bannerContainer.addChild(imageLoader);

        // 3. Create "LATEST ON MAX" Badge Tag (Mimicking the retro orange corner banner)
        createLatestBadge();

        // 4. Create Thumbnail Selection Boxes Below
        thumbContainer = new Sprite();
        thumbContainer.y = 265; // Positioned right below the main 260px banner
        thumbContainer.x = 200; // Aligned towards the right side like the screenshot
        addChild(thumbContainer);

        createThumbnails();

        // 5. Load the first slide
        showSlide(0);

        // 6. Setup 5-Second Auto-Rotation Timer (5000 milliseconds)
        timer = new Timer(5000);
        timer.addEventListener(TimerEvent.TIMER, onTimerTick);
        timer.start();
    }

    private function showSlide(index:Int):Void {
        currentIndex = index;
        
        // Load main image
        var req = new URLRequest(slides[currentIndex].image);
        imageLoader.load(req);

        // Update active state visual style for thumbnails
        updateThumbUI();
    }

    private function onTimerTick(event:TimerEvent):Void {
        currentIndex = (currentIndex + 1) % slides.length;
        showSlide(currentIndex);
    }

    private function onBannerClick(event:MouseEvent):Void {
        var targetUrl:String = slides[currentIndex].link;
        
        // Conditional Check: Only redirect if a valid URL string is present
        if (targetUrl != null && targetUrl != "") {
            var request = new URLRequest(targetUrl);
            navigateToURL(request, "_self");
        }
        // If link is empty, clicking does nothing (just shows the image)
    }

    private function createThumbnails():Void {
        thumbs = [];
        var startX:Float = 0;
        var spacing:Float = 35; // Gap between small thumbnail boxes

        for (i in 0...slides.length) {
            var thumbBox = new Sprite();
            thumbBox.x = startX + (i * spacing);
            thumbBox.buttonMode = true;
            
            // Draw retro orange box background matching screenshot
            thumbBox.graphics.beginFill(0xFF6600);
            thumbBox.graphics.lineStyle(1, 0xFFFFFF);
            thumbBox.graphics.drawRect(0, 0, 30, 30);
            thumbBox.graphics.endFill();

            // Store index reference for clicking
            var slideIndex = i;
            thumbBox.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
                showSlide(slideIndex);
                timer.reset(); // Restart timer so manual click doesn't instantly jump
                timer.start();
            });

            thumbContainer.addChild(thumbBox);
            thumbs.push(thumbBox);
        }
    }

    private function updateThumbUI():Void {
        for (i in 0...thumbs.length) {
            if (i == currentIndex) {
                // Highlight active thumbnail
                thumbs[i].alpha = 1.0;
                thumbs[i].scaleX = 1.05;
                thumbs[i].scaleY = 1.05;
            } else {
                // Dim unselected thumbnails
                thumbs[i].alpha = 0.7;
                thumbs[i].scaleX = 1.0;
                thumbs[i].scaleY = 1.0;
            }
        }
    }

    private function createLatestBadge():Void {
        var badge = new Sprite();
        badge.x = 10;
        badge.y = 220;

        // Orange ribbon background
        badge.graphics.beginFill(0xEE5500);
        badge.graphics.drawRect(0, 0, 110, 35);
        badge.graphics.endFill();

        // Text format for "LATEST ON MAX"
        var tf = new TextField();
        var format = new TextFormat("_sans", 11, 0xFFFFFF, true);
        tf.defaultTextFormat = format;
        tf.text = "LATEST\nON MAX";
        tf.x = 8;
        tf.y = 3;
        tf.mouseEnabled = false;

        badge.addChild(tf);
        addChild(badge);
    }
}
