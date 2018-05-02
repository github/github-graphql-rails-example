function loadMoreRepositories(link) {
  var container = link.parentElement;
  container.classList.add('loading');

  fetch(link.href).then(function(response) {
    response.text().then(function(text) {
      container.insertAdjacentHTML('afterend', text);
      container.remove();
    })
  })
}

function toggleStar(el) {
  fetch(el.action, { method: 'PUT', headers: { 'X-Requested-With': 'XMLHttpRequest' } }).then(function(response) {
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

document.addEventListener('submit', function(e) {
  var form = e.target
  toggleStar(form)
  e.preventDefault()
})

// Basic event delegation
document.addEventListener('click', function(e) {
  var loadMoreLink = e.target.closest('.js-load-more')
  if (loadMoreLink) {
    loadMoreRepositories(loadMoreLink)
    e.preventDefault()
  }
})
