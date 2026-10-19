WRITENOW STRESS TESTS

The tests drive the shipped page (windows/index.html) inside an
iframe: hostile imports and pastes, odd file names, search/replace edge cases,
very large documents, a full or broken localStorage, corrupted saved data,
broken PDFs, key and menu fuzzing.

Run them on any computer (Windows, Mac or Linux) with a browser and Python:

    python build.py                      (once, after editing writenow.html)
    python -m http.server 8794           (in this project folder)

then open  http://localhost:8794/tests/stress.html  in the browser you want to
check (Chrome, Edge, Firefox, Safari). The summary at the top reads
"N / N passed". Add  ?only=PDF  to run just the tests whose name contains PDF.
The tests need internet for the PDF tests (the PDF reader loads from a CDN).
