/* ========================================================
スクロールでトップに戻るボタンを表示
=========================================================*/
// スクロールして何ピクセルでアニメーションさせるか
const px_change = 1;
// スクロールのイベントハンドラを登録
window.addEventListener('scroll', function(e) {
  // 変化するポイントまでスクロールしたらクラスを追加
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
  if ( scrollTop > px_change ) {
    document.getElementById( "btn-backtotop" ).classList.add( "fadein" );

  // 変化するポイント以前であればクラスを削除
  } else {
    document.getElementById( "btn-backtotop" ).classList.remove( "fadein" );
  }
});