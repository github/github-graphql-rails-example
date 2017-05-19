function loadMoreRepositories(event) {
  var container = event.target.parentElement;
  container.classList.add('loading');

  var xhr = new XMLHttpRequest();
  xhr.open('GET', event.target.href, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.onload = function() {
    container.insertAdjacentHTML('afterend', xhr.responseText);
    container.remove();
  }
  xhr.send();
}

function toggleStar(el) {
  fetch(el.href, { method: 'PUT' }).then(function(response) {
    response.text().then(function(text) {
      // Parse text to get an actual element
      var div = document.createElement('div')
      div.innerHTML = text

      // Find the star container
      var container = el.closest('.star-badge')
      container.replaceWith(div.firstElementChild)
    })
  })
}

// Basic event delegation
document.addEventListener('click', function(e) {
  var toggleLink = e.target.closest('.js-toggle-star')
  if (toggleLink) {
    toggleStar(toggleLink)
    e.preventDefault()
  }

  var loadMoreLink = e.target.closest('.js-load-more')
  if (loadMoreLink) {
    loadMoreRepositories(e)
    e.preventDefault()
  }
})
