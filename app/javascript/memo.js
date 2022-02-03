const buildHTML = (XHR) => {
  const item = XHR.response.comment;
  const userName = XHR.response.user;
  const now = new Date()
  const year = now.getFullYear();
  const month = ("0" + (now.getMonth()+1)).slice(-2);
  const date = ("0" + now.getDate()).slice(-2);
  const html = `
    <div class="comment-text">
    <strong><a href="/users/${item.user_id}" class="comment-nickname">${userName.nickname}</a>：</strong>
    ${item.comment}
    <div class="comment-time">(${year}/${month}/${date})</div>
    </div>`;
  return html;
};

function comment (){
  const submit = document.getElementById("comment-submit");

  submit.addEventListener("click", (e) => {
    e.preventDefault();
    const form = document.getElementById("comment-form");
    const formData = new FormData(form);
    const XHR = new XMLHttpRequest();
    const restaurantId = form.getAttribute("action")
    XHR.open("POST", restaurantId, true);
    XHR.responseType = "json";
    XHR.send(formData);
    XHR.onload = () => {
      if (XHR.status != 200) {
        alert(`Error ${XHR.status}: ${XHR.statusText}`);
        return null;
      };
      const list = document.getElementById("list");
      const formText = document.getElementById("comment-text");
      list.insertAdjacentHTML("afterend", buildHTML(XHR));
      formText.value = "";
    };
  });
 };
 
 window.addEventListener('load', comment);