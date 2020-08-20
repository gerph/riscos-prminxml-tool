#!/usr/bin/perl
##
# PRMinXML generation tool.
#
# This tool is intended to build documentation using the PRMinXML
# stylesheets.
#
# This script should be a perl 5.0 tool which can be used under
# RISC OS or POSIX systems.
#
# At the present time it has not been tested under RISC OS.
#
# Requires:
#   Native xsltproc (when processing individual files)
#   Native make (when generating multiple indexed files)
#

my $riscos = ($^O eq '') || ($^O eq 'riscos');
my $script = "$0";
my $scriptdir = $script;
my $resourcedir;
if ($riscos)
{
    $scriptdir =~ s/\.[^\.]+$//;
    $resourcedir = "$scriptdir/riscos-prminxml-resources";
    if (!-d $resourcedir)
    {
        # Not yet installed
        $resourcedir = "$scriptdir.catalog";
    }
}
else
{
    $scriptdir =~ s/\/[^\/]+$//;
    $resourcedir = "$scriptdir/riscos-prminxml-resources";
    if (!-d $resourcedir)
    {
        # Not yet installed
        $resourcedir = "$scriptdir/catalog";
    }
}

my $debug = 0;
my $format = 'html';
my $outputdir = undef;
my $outputfile = undef;
my $tool = 'xsltproc';
my $catalog_base = 'http://www.movspclr.co.uk/dtd';
my $catalog_version = '102';
my $logdir = undef;
my $logfile = undef;
my $index = undef;

# Extensions to use for each format
my %extensions = (
        'html' => 'html',
        'header' => 'h',
        'command' => 'txt',
        'stronghelp' => undef,

        'index' => undef, # Special value
    );


while (my $arg = shift)
{
    #print "Arg = $arg\n";
    if ($arg =~ /^-(-?)([a-zA-Z]+)/)
    {
        my ($double, $arg) = ($1, $2);
        my @args = ();
        if ($double)
        {
            # Long options are given by name.
            push @args, $arg;
        }
        else
        {
            # Single character arguments are broken up.
            push @args, split //, $arg;
        }

        for $arg (@args)
        {
            if ($arg eq 'help' or $arg eq 'h')
            {
                help();
                exit(0);
            }
            elsif ($arg eq 'debug' or $arg eq 'd')
            {
                $debug = 1;
            }
            elsif ($arg eq 'format' or $arg eq 'f')
            {
                $format = shift;
                if (! exists $extensions{$format})
                {
                    die "Format '$format' is not known\n";
                }
            }
            elsif ($arg eq 'logdir' or $arg eq 'L')
            {
                $logdir = shift;
            }
            elsif ($arg eq 'logfile' or $arg eq 'l')
            {
                $logfile = shift;
            }
            elsif ($arg eq 'outputdir' or $arg eq 'O')
            {
                $outputdir = shift;
            }
            elsif ($arg eq 'output' or $arg eq 'o')
            {
                my $output = shift;
                # Convenience; if they give us a directory, we just use that
                if (-d $output)
                {
                    $outputdir = $output;
                }
                else
                {
                    $outputfile = $output;
                }
            }
        }
    }
    else
    {
        unshift @ARGV, $arg;
        last;
    }
}

# See if we can read what the input files are.
my @inputs = ();
while (my $f = shift)
{
    if (! -f $f)
    {
        # FIXME: Should we allow non-local file resources? (eg http resources?)
        die "Input '$f' is not a file\n";
    }
    push @inputs, $f;
}

if (scalar(@inputs) == 0)
{
    die "No input files supplied\n";
}
if (scalar(@inputs) > 1 && defined($outputfile))
{
    die "Cannot process multiple outputs to a single output file\n";
}

if (defined $logdir && ! -d $logdir)
{
    die "Log directory '$logdir' does not exist\n";
}


my $rc = 0;

if ($format eq 'index')
{
    # Special case for the 'index' format - we take an index.xml file and we build everything
    # described in it and give it a common structure.
    if (scalar(@inputs) != 1)
    {
        die "For 'index' format, only a single file, the index.xml file, should be supplied\n";
    }

    if ($^O eq 'riscos')
    { $tempbase = "<Wimp\$ScrapDir>.prmlxml-$$"; }
    else
    { $tempbase = "/tmp/prmxml-$$"; }

    if (defined $outputdir)
    {
        die "For 'index' format, the output directory should be supplied in the index.xml file\n";
    }

    if (!defined $logdir)
    {
        die "For 'index' format, a log directory must be supplied\n";
    }

    my $indexxml = $inputs[0];
    my $step = 1;

    # Build the makefile
    print "Building makefile\n";
    my $makefile = "$tempbase-Makefile";
    # FIXME: Should we use the makefile-ro for RISC OS? Does that work any more?
    my $xslt = "$catalog_base/$catalog_version/prmindex-makefile.xsl";
    my $cmd = "$tool -stringparam index-xml \"$indexxml\" $xslt \"$indexxml\" > \"$makefile\"";
    runcommand($cmd) && die "Unable to generate makefile with: $cmd\n";

    # Clean
    print "Cleaning target\n";
    $cmd = "make -f \"$makefile\" clean > \"$logdir/$step-clean.log\"";
    $cmd .= " 2>&1" if (!$riscos);
    runcommand($cmd) && die "Unable to clean directories with: $cmd\n";
    $step += 1;

    # Build
    print "Building documentation\n";
    $cmd = "make -f \"$makefile\" > \"$logdir/$step-build.log\"";
    $cmd .= " 2>&1" if (!$riscos);
    runcommand($cmd) && die "Unable to build documentation with: $cmd\n";
    $step += 1;

    # Validate
    print "Validating source\n";
    $cmd = "make -f \"$makefile\" validate > \"$logdir/$step-validate.log\"";
    $cmd .= " 2>&1" if (!$riscos);
    runcommand($cmd) && die "Unable to validating documentation with: $cmd\n";
    $step += 1;

    # If we get to here, we'll clear away the file.
    unlink($tempbase);
}
else
{
    if (!defined $outputdir)
    {
        if ($riscos)
        { $outputdir = '@'; }
        else
        { $outputdir = '.'; }
    }
    my $first = 1;
    for $input (@inputs) {
        my $xslt = "$catalog_base/$catalog_version/prm-$format.xsl";
        my $out;
        if (defined($outputfile))
        {
            $out = $outfile;
            if ($riscos)
            {
                if ($outputfile !~ /[:\$@%\\]/)
                {
                    $out = "$outputdir.$outputfile";
                }
            }
            else
            {
                if ($outputfile !~ /^\//)
                {
                    $out = "$outputdir/$outputfile";
                }
            }
        }
        else
        {
            my $leaf = leafname($input);
            $leaf = replaceext($leaf, $extensions{$format});
            if ($riscos)
            { $out = "$outputdir." . $leaf; }
            else
            { $out = "$outputdir/" . $leaf; }
        }
        print "Processing $input -> $out\n";
        my $cmd = "$tool -output \"$out\" $xslt \"$input\"";

        if ($logfile or $logdir)
        {
            # They want a log file writing out.
            my $log;
            if ($logfile)
            {
                $log = $logdir ? "$logdir/$logfile" : "$logfile";

                # They wanted just one log file.
                open(OUT, ">> $log") || die "Cannot access log file '$log': $!\n";
                print OUT "--- $input -> $output ---\n";
                close OUT;
            }
            else
            {
                # They gave a log directory, so we want to create one file per input
                my $leaf = leafname($input);
                $leaf = replaceext($leaf, 'log');
                $log = "$logdir/" . $leaf;
            }
            if ($riscos)
            {
                $cmd .= " > $log";
            }
            else
            {
                $cmd .= " > \"$log\" 2>&1";
            }
        }

        my $cmdrc = runcommand($cmd);
        if ($cmdrc != 0)
        {
            # Any type of failure means that we'll return a failure.
            $rc =1;
        }
        $first = 0;
    }
}


exit($rc);


##
# Return the directory name of a file.
sub dirname
{
    my ($f) = @_;
    if ($riscos)
    { $f =~ s/\.[^\.]+$//; }
    else
    { $f =~ s/\/[^\/]+$//; }
    return $f;
}


##
# Return the leafname of a file.
sub leafname
{
    my ($f) = @_;
    if ($riscos)
    { $f =~ s/^.*\.([^\.]+)$/$1/; }
    else
    { $f =~ s/^.*\/([^\/]+)$/$1/; }
    return $f;
}


##
# Replace extension with a new one
sub replaceext
{
    my ($f, $ext) = @_;
    if ($riscos)
    {
        if (! $ext)
        { $f =~ s/^([^\.]+)\/[^\.]+$/$1/; }
        else
        { $f =~ s/^([^\.]+)\/[^\.]+$/$1\/$ext/; }
    }
    else
    {
        if (! $ext)
        { $f =~ s/^([^\/]+)\.[^\/]+$/$1/; }
        else
        { $f =~ s/^([^\/]+)\.[^\/]+$/$1.$ext/; }
    }
    return $f;
}


##
# Run a command and return the return code (in perl format)
sub runcommand
{
    my ($cmd) = @_;

    my $oldenv = $ENV{'XML_CATALOG_FILES'};
    # Use the catalog files that we supplied.
    $ENV{'XML_CATALOG_FILES'} = "$resourcedir/root.xml";

    print "Command: $cmd\n" if ($debug);
    my $rc = system "$cmd";
    print "RC is $rc\n" if ($debug);

    # Restore the old environment variable on RISC OS
    if (defined $oldenv) {
        $ENV{'XML_CATALOG_FILES'} = $oldenv;
    }
    else {
        delete $ENV{'XML_CATALOG_FILES'};
    }
    return $rc;
}


##
# Print help messages.
sub help
{
    my $tool = $riscos ? 'prminxml' : 'riscos-prminxml';
    my $version = 'VERSION';
    print "$tool $version - converts structured documentation to presentation formats\n";
    print "Syntax: $tool <options> <input-files>\n";

    my $formats = join ', ', sort keys %extensions;
    print <<EOM;
Options:

    --help, -h      This help message
    --debug, -d     Enable debug
    --format <format>, -f <format>
                    Format to render into ($formats)
    --logfile <file>, -l <file>
                    Log file to write to
    --logdir <dir>, -L <dir>
                    Log directory (for writing multiple files)
    --output <file>, -o <file>
                    Output file (or directory) to write to
    --outputdir <dir>, -O <dir>
                    Output directory to use

The 'html' format is the most common. Usually you would use a command like:

    $tool -O outputdir mydocs.xml

The 'header' format outputs a C header file for the constants from the file:

    $tool -f header -O outputdir mydocs.xml

The 'command' format outputs a command line help file suitable for passing
through VTranslate:

    $tool -f command -O outputdir mydocs.xml

The 'stronghelp' format outputs a skeleton StrongHelp directory structure:

    $tool -f stronghelp -O outputdir mydocs.xml

The 'index' format is more complex; it can take an 'index.xml' file which
describes many documents to be included in the structured output documentation:

    $tool -f index index.xml

The 'index.xml' file has the following format:

----
<?xml version="1.0"?>
<index>
<dirs output="output/html"
      help="output/help"
      header="output/header"
      input="src"
      temp="tmp" />
<options
    hide-empty="no"
    include-source="no"
    make-contents="no"
    />

<make-index type="swi" />
<make-index type="command" />
<make-index type="message" />
<make-index type="upcall" />
<make-index type="service" />
<make-index type="sysvar" />
<make-index type="entry" />
<make-index type="vector" />
<make-index type="error" />
<make-index type="vdu" />
<make-index type="tboxmessage" />
<make-index type="tboxmethod" />
<make-index type="section" />

<footer>
Your Disclaimer Here.
</footer>

<section title="Overview" dir="overview">
 <page href="about">About this documentation</page>
 <page href="more">More documentation</page>
</section>
</index>
----

The 'dirs' element describes where content should be read and written to:

    output: where the HTML output should be put
    help:   where the command output should be put
    header: where the C header output should be put
    input:  the base directory for source XML files
    temp:   a temporary directory which can be used during build

The 'options' element describes some settings for the index build:

    hide-empty:     'yes' or 'no': whether pages without a href will
                    be omitted
    include-source: 'yes' or 'no': whether source XML files will be
                    linked in the index (they'll always be copied).
    make-contents:  'yes' or 'no': whether the contents with inline
                    section details will be generated. This allows
                    you to see the indexed elements inline with the
                    contents. It's not especially useful in reality.

The 'make-index' elements describe which parts of the indexes will
be included in the output.

The 'footer' element can contain text to place at the bottom of the
index pages (individual pages may have their own explicit disclaimer,
which is distinct from this footer).

The 'section' elements may be repeated and nested. These define the
sections of the documentation, with head being further nested than
the others. The 'dir' attribute must be populated with the name of
the directory the section describes - sections and pages must be
stored in the same hierarchy as described in this document.

The 'page' element describes a page (chapter, really) which will be
linked from the index. If a 'href' attribute is given, the document
will be generated and linked. If a 'href' attribute is not given,
the page will be unlinked (or omitted if 'hide-empty' is 'yes').

Information about the PRM-in-XML format can be found in the directory:
    $resourcedir/gerph

EOM
}
