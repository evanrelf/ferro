# ferro

Send articles to your Kindle.


## Development

This is very much a work in progress.

MVP:

- [x] Accept URL as command-line argument
- [x] Download webpage's HTML
- [x] Clean HTML ("readability")
- [ ] Convert HTML to [`.mobi` e-book file format][mobi] accepted by Kindle
      devices using [Pandoc][pandoc] + [calibre][calibre]
- [ ] Send `.mobi` file over email to Kindle (via SMTP w/ my personal email
      provider)

Future ideas:

- REST API
- Web UI
- Bookmarklet or browser extension
- Keep track of sent articles in a database for read-it-later functionality
- More sophisticated HTML cleanup logic (e.g. fix relative image links, preserve
  positioning of elements, etc.)
- Send emails with AWS SES or SendGrid
- Watch RSS feeds or query feed reader API

Most of these I probably won't need or get to.


## Name

The name is a reference to [ferrocerium][ferrocerium], an iron alloy used in
lighters that produces hot sparks when struck.

[pandoc]: https://pandoc.org/
[calibre]: https://calibre-ebook.com/
[mobi]: https://en.wikipedia.org/wiki/Mobipocket
[ferrocerium]: https://en.wikipedia.org/wiki/Ferrocerium


## License

TBD, based on what libraries and tools I use. I suspect it will have to use GPL
v3.0, since Pandoc is GPL v2.0 and calibre is GPL v3.0.
