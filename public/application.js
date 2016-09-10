function loadMoreRepositories(event) {
  var container = event.target.parentElement;
  container.classList.add('loading');
  event.preventDefault();

  var xhr = new XMLHttpRequest();
  xhr.open('GET', event.target.href, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.onload = function() {
    container.insertAdjacentHTML('afterend', xhr.responseText);
    container.remove();
  }
  xhr.send();
}
