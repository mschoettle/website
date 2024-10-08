document$.subscribe(function () {
  // Find [Abstract] links and add a click handler to show and hide the abstract admonition
  for (element of document.getElementsByTagName('a')) {
    if (element.text == '[Abstract]') {
      element.addEventListener('click', function (event) {
        event.preventDefault()
        let abstract = event.target.parentNode.nextElementSibling
        abstract.classList.toggle('hidden')
      })
    }
  }

  // Find [BibTeX] links and add a click handler to show and hide the cite admonition
  for (element of document.getElementsByTagName('a')) {
    if (element.text == '[BibTeX]') {
      element.addEventListener('click', function (event) {
        event.preventDefault()
        let bibtex = event.target.parentNode.nextElementSibling.nextElementSibling
        bibtex.classList.toggle('hidden')
      })
    }
  }
})
