# Example content

The example content in this directory is intended to use to check that the features
of the PRM-in-XML content are handled by the stylesheets in a useful way. They're not
automatically tested as checking the content between revisions would be a difficult
task.

They are commonly reviewed to identify differences between stylesheets and
transformations. To build these documents into HTML files, use:

    cd crosscompile
    ./build-examples.sh

To build PDF documents as well, use:

    cd crosscompile
    env PRINCEXML_I_HAVE_A_LICENSE=1 ./build-examples.sh
