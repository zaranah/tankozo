$(function() {
  $('.rank-class').slick({
    autoplay: true,
    autoplaySpeed: 0,
    speed: 5000,
    cssEase: "linear", // スピード等速
    slidesToShow: 1,
    centerMode: true,
    centerPadding: '100px',
    focusOnSelect: true,
    swipe: true, // 操作による切り替え
    arrows: false, //矢印非表示

    responsive: [{
      breakpoint: 600,
      settings: {
        slidesToShow: 1,
        centerPadding: '10px',
      }
    }]
  });
});
