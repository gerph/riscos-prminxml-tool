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
#   Native xmllint (when linting individual files)
#   Native make (when generating multiple indexed files)
#

my $riscos = ($^O eq '') || ($^O eq 'riscos');
my $script = "$0";
my $scriptdir = $script;
my $resourcedir;
my $dirsep = $riscos ? '.' : '/';
my $extsep = $riscos ? '/' : '.';
my $envvar;
if ($riscos)
{
    if (! ($scriptdir =~ s/\.[^\.]+$//))
    {
        $scriptdir = "@";
    }
    $resourcedir = "$scriptdir${dirsep}riscos-prminxml-resources";
    if (!-d $resourcedir) {
        # May have been installed into the XMLCatalog resource
        if (-d '<XMLCatalog$Dir>.gerph') {
            $resourcedir = '<XMLCatalog$Dir>';
        }
    }
    $envvar_catalog = 'XML$CatalogFiles';
}
else
{
    if (! ($scriptdir =~ s/\/[^\/]+$//))
    {
        $scriptdir = ".";
    }
    $resourcedir = "$scriptdir${dirsep}riscos-prminxml-resources";
    $envvar_catalog = 'XML_CATALOG_FILES';
}
if (!-d $resourcedir)
{
    # Not yet installed
    $resourcedir = "$scriptdir${dirsep}catalog";
}

my $toolname = $riscos ? 'prminxml' : 'riscos-prminxml';
my $version = 'VERSION';
my $debug = 0;
my $lint = 0;
my $format = 'html';
my $outputdir = undef;
my $outputfile = undef;
my $tool = 'xsltproc';
my $toollint = 'xmllint';
my $catalog_base = 'http://gerph.org/dtd';
my $catalog_version = '103';
my $logdir = undef;
my $logfile = undef;
my $index = undef;
my $params = {};

my $tempbase = $riscos ? "<Wimp\$ScrapDir>.prmlxml-$$" : "/tmp/prmxml-$$";

# Extensions to use for each format
my %extensions = (
        'html' => 'html',
        'html5' => 'html',
        'html+xml' => 'html',
        'html5+xml' => 'html',
        'header' => 'h',
        'command' => 'txt',
        'stronghelp' => undef,

        'index' => undef, # Special value
        'lint' => undef, # Special value
        'skeleton' => undef, # Special value
    );
my @valid_formats = (
        'header',
        'command',
        'stronghelp',
        'html',
        'html5',
    );

my $arg;
while ($arg = shift)
{
    #print "Arg = $arg\n";
    if ($arg =~ /^-(-?)([a-zA-Z\-]+)/)
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
            elsif ($arg eq 'help-indexed')
            {
                help_indexed();
                exit(0);
            }
            elsif ($arg eq 'help-params')
            {
                help_params();
                exit(0);
            }
            elsif ($arg eq 'version' or $arg eq 'V')
            {
                version();
                exit(0);
            }
            elsif ($arg eq 'catalog' or $arg eq 'C')
            {
                $catalog_version = shift;
            }
            elsif ($arg eq 'debug' or $arg eq 'd')
            {
                $debug = 1;
            }
            elsif ($arg eq 'help-tag')
            {
                $helptag = shift;
                help_tag($helptag);
                exit(0);
            }
            elsif ($arg eq 'lint')
            {
                $lint = 1;
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
            elsif ($arg eq 'param' or $arg eq 'p')
            {
                my $param = shift;
                my ($name, $value) = ($param =~ /^([a-zA-Z\-]+)=(.*)$/);
                if (!$name)
                {
                    die "Parameter should be given in the form '<name>=<value>'\n";
                }
                $params{$name} = $value;
            }
        }
    }
    else
    {
        #print "Push back $arg\n";
        print ""; # Some bug in the perl interpreter causes the unshift to be ignored without this?!
        unshift @ARGV, $arg;
        last;
    }
}


# See if we can read what the input files are.
my @inputs = ();
my $f;
while ($f = shift)
{
    #print "Arg: Bare filename $f\n";
    my $nf = native_filename($f);
    if (!$nf)
    {
        # FIXME: Should we allow non-local file resources? (eg http resources?)
        die "Input '$f' is not a file\n";
    }
    push @inputs, $nf;
}

if ($format eq 'skeleton')
{
    if (!defined $outputfile)
    {
        die "No output file defined for skeleton\n";
    }

    if (-f $outputfile)
    {
        die "Skeleton output file '$outputfile' already exists - refusing to overwrite\n";
    }
    $skeleton = "$resourcedir${dirsep}gerph${dirsep}skeleton${extsep}xml";

    copyfile($skeleton, $outputfile, 'skeleton source', 'skeleton output');
    print "Created $outputfile\n";
    print "To create HTML from this, use:\n";
    my $newfile = replaceext($outputfile, "html");
    print "    $0 -f html5 -o $newfile $outputfile\n";
    exit 0;
}

if (scalar(@inputs) == 0)
{
    die "No input files supplied\n";
}
if (scalar(@inputs) > 1 && defined($outputfile))
{
    die "Cannot process multiple outputs to a single output file\n";
}

if (defined $logdir)
{
    my $nlogdir = native_filename($logdir, 'd');
    if (!$nlogdir)
    {
        die "Log directory '$logdir' does not exist\n";
    }
    $logdir = $nlogdir;
}

if (defined $outputdir)
{
    my $noutput = native_filename($outputdir, 'd');
    if (!$noutput)
    {
        die "Output directory '$outputdir' does not exist\n";
    }
    $outputdir = $noutput;
}

my $rc = 0;

if ($format eq 'index')
{
    # Special case for the 'index' format - we take a index.xml file and we build everything
    # described in it and give it a common structure.
    if (scalar(@inputs) != 1)
    {
        die "For 'index' format, only a single file, the index.xml file, should be supplied\n";
    }

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
    my $cmd = "$tool";
    $cmd .= " -stringparam index-xml \"$indexxml\"";
    $cmd .= " $xslt \"$indexxml\" > \"$makefile\"";
    runcommand($cmd) && die "Unable to generate makefile with: $cmd\n";
    #print("Made makefile: $makefile\n");
    #<STDIN>;

    # Clean
    print "Cleaning target\n";
    $cmd = "make -f \"$makefile\" clean > \"$logdir${dirsep}$step-clean${extsep}log\"";
    $cmd .= " 2>&1" if (!$riscos);
    runcommand($cmd) && die "Unable to clean directories with: $cmd\n";
    $step += 1;

    # Build
    print "Building documentation\n";
    my $logfile;
    $logfile = "$logdir${dirsep}$step-build${extsep}log";
    build_with_log("make -f \"$makefile\"", $logfile, "build documentation");
    $step += 1;

    if ($lint)
    {
        # Validate
        print "Validating source\n";
        $logfile = "$logdir${dirsep}$step-validate${extsep}log";
        build_with_log("make -f \"$makefile\" validate", $logfile, "validate documentation", 1);
        $step += 1;

        # Report on the validity errors
        if (check_lint_log($logfile) && $lint)
        {
            $rc  = 1;
        }
    }
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
    my $copy_xml = 0;
    if ($format =~ s/\+xml$//)
    {
        $copy_xml = 1;
    }

    for $input (@inputs) {
        my $xslt = "$catalog_base/$catalog_version/prm-$format.xsl";
        my $out;
        my $cmd;
        if (defined($outputfile))
        {
            $out = $outputfile;
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
            $out = "$outputdir${dirsep}$leaf";
        }
        print "Processing $input -> $out\n";

        my $logtail = '';
        my $log;
        if ($logfile or $logdir)
        {
            # They want a log file writing out.
            if ($logfile)
            {
                $log = $logdir ? "$logdir${dirsep}$logfile" : "$logfile";

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
                $log = "$logdir${dirsep}$leaf";
            }
            if ($riscos)
            {
                $logtail = " > $log";
            }
            else
            {
                $logtail = " > \"$log\" 2>&1";
            }
        }

        if ($lint)
        {
            # They requested linting first; so we need to check the file
            $cmd = "$toollint --noout --valid \"$input\"";
            if ($riscos)
            {
                $cmd .= " > $tempbase";
            }
            else
            {
                $cmd .= " > \"$tempbase\" 2>&1";
            }
            my $cmdrc = runcommand($cmd);
            if ($cmdrc != 0)
            {
                # Any lint failure, when requested, is an overall failure
                $rc = 1;
                print "  Linting failed with rc=".($cmdrc>>8)."\n";
            }
            # Copy the file to any log we have
            open(IN, "< $tempbase") || die "Cannot read temporary log file '$tempbase': $!\n";
            if ($log)
            {
                # If they specified a log, then everything should go to the log
                open(OUT, ">> $log") || die "Cannot update log file '$log': $!\n";;
                while (<IN>)
                {
                    print OUT;
                }
                close(OUT)
            }
            else
            {
                # No log supplied, so we should write to the display
                while (<IN>)
                {
                    print;
                }
            }
            close(IN);

            # Report on the validity errors
            if (check_lint_log($tempbase, $input))
            {
                # There were failures, so that means we return a failure from this command
                $rc = 1;
            }
        }

        if ($format eq 'lint')
        {
            my $native = $riscos ? '--native' : '';
            $cmd = "$toollint $native --noout --valid \"$input\"";
        }
        else
        {
            my $native = $riscos ? '--native' : '';
            my $cliparams = join(' ', map { "--stringparam $_ \"$params{$_}\"" } sort keys %params);
            $cmd = "$tool $native $cliparams --output \"$out\" $xslt \"$input\"";
        }
        $cmd .= $logtail;

        my $cmdrc = runcommand($cmd);
        if ($cmdrc != 0)
        {
            # Any type of failure means that we'll return a failure.
            $rc = 1;
        }
        else
        {
            # Success, so see copy the XML, if we need to.
            if ($copy_xml)
            {
                my $outxml = replaceext($out, 'xml');
                print "  Copying -> $outxml\n";
                copyfile($input, $outxml);
            }
        }
    }

}

# If we get to here, we'll clear away the file.
unlink($tempbase);

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
        { $f =~ s/(^|\.)([^\.]+)\/[^\.]+$/$1$2/; }
        else
        { $f =~ s/(^|\.)([^\.]+)\/[^\.]+$/$1$2\/$ext/; }
    }
    else
    {
        if (! $ext)
        { $f =~ s/(^|\/)([^\/]+)\.[^\/]+$/$1$2/; }
        else
        { $f =~ s/(^|\/)([^\/]+)\.[^\/]+$/$1$2.$ext/; }
    }
    return $f;
}


##
# Copy a file to a new location.
sub copyfile
{
    my ($src, $dst, $srcname, $dstname) = @_;
    open(IN, "< $src") || die "Cannot read $srcname file '$src': $!\n";

    open(OUT, "> $dst") || die "Cannot write to $dstname file '$dst': $!\n";
    while (<IN>)
    {
        print OUT;
    }
    close(OUT);
    close(IN);
}


##
# Expand a RISC OS variable on non-RISC OS system.
sub expand_variable
{
    my ($var) = @_;
    my $uvar = $var;
    $uvar = uc $uvar;
    $uvar =~ tr/$/_/;
    if (defined $ENV{$uvar})
    {
        return $ENV{$uvar};
    }
    return "<$var>";
}


##
# Convert a filename supplied into a native format.
sub native_filename
{
    my ($f, $type) = @_;
    $type ||= 'f';

    if (($type eq 'f' && -f $f) ||
        ($type eq 'd' && -d $f))
    {
        # Already a native filename; that's fine.
        return $f;
    }

    if (!$riscos)
    {
        # We're not on RISC OS.
        my $rof = $f;
        # Let's see if we can swap the convention to native style
        $rof =~ tr!./!/.!;

        # And replace any variable expansions.
        $rof =~ s/<([A-Za-z0-9_\$]+)>/expand_variable($1)/ge;

        if (($type eq 'f' && -f $rof) ||
            ($type eq 'd' && -d $rof))
        {
            # Just swapping the directory and extensions around appeared to work
            return $rof;
        }
        if ($rof =~ m!/xml$!)
        {
            # It ends in .xml so it could have been given a filetype.
            if (($type eq 'f' && -f "$rof,f80") ||
                ($type eq 'd' && -d "$rof,f80"))
            {
                # Gotcha
                return "$rof,f80";
            }
        }
    }
    else
    {
        # We're on RISC OS, we might have been given a unix style filename.
        # FIXME: Not implemented.
    }
    return undef;
}


##
# Run a command and return the return code (in perl format)
sub runcommand
{
    my ($cmd) = @_;

    my $oldenv = $ENV{$envvar_catalog};
    # Use the catalog files that we supplied.
    my $need_restore = 0;
    my $catalog = "${resourcedir}${dirsep}root${extsep}xml";
    if (-f "$catalog") {
        # Only use the resource catalog if one is present; otherwise we'll fall back to the
        # system catalogs or fetching from the network if possible.
        $need_restore = 1;
        $ENV{$envvar_catalog} = $catalog;
    }

    print "Command: $cmd\n" if ($debug);
    my $rc = system "$cmd";
    print "RC is $rc\n" if ($debug);

    # Restore the old environment variable on RISC OS
    if ($need_restore) {
        if (defined $oldenv) {
            $ENV{$envvar_catalog} = $oldenv;
        }
        else {
            delete $ENV{$envvar_catalog};
        }
    }
    return $rc;
}


##
# Build using a command, with a log which we report on failure.
#
# Note: Will die if there is a failure.
#
# @param $cmd       The command to run
# @param $logfile   Where the logfile should go
# @param $type      The build type, as a readable string
# @param $always_print  Always output the logs
sub build_with_log
{
    my ($cmd, $logfile, $type, $always_print) = @_;
    $cmd = "$cmd > \"$logfile\"";
    $cmd .= " 2>&1" if (!$riscos);
    my $rc = runcommand($cmd);
    if ($rc || $always_print)
    {
        if ($rc) {
            print "Failed to $type; log follows:\n";
        }
        else {
            print "  Log for $type:\n";
        }
        if (! open(LOG, "< $logfile"))
        {
            print "ERROR: Cannot read log '$logfile': $!\n";
        }
        else
        {
            while (<LOG>)
            {
                if (/^Processing|xsltproc/)
                {
                    # This is a heading block.
                    print "  $_";
                }
                else
                {
                    print "    $_";
                }
            }
        }
    }
    if ($rc)
    {
        die "Unable to $type with: $cmd\n";
    }
}


##
# Check a log containing lint information.
#
# @param $logfile       The file holding the lint information
# @param $infile        The initial file we are parsing, or undef if none
#
# @return:      Number of failures seen
sub check_lint_log
{
    my ($logfile, $infile) = @_;
    open(LOG, "< $logfile") || die "Could not read validation log file '$logfile': $!\n";
    my $onefile = defined($infile);
    my $nfails = 0;
    my %badfiles;
    while (<LOG>)
    {
        if (/^xmllint.* (\S*)\n?$/)
        {
            my $cmd = $_;
            $infile = $1;
        }
        if (/validity error/)
        {
            $nfails++;
            $badfiles{$infile} = ($badfiles{$infile} || 0) + 1;
        }
    }
    close(LOG);
    if ($nfails > 0)
    {
        print "  Validation failures: $nfails\n";
        if (!$onefile)
        {
            print "  Failure breakdown:\n";
            for $file (sort(keys %badfiles))
            {
                printf "  %4i : %s\n", $badfiles{$file}, $file;
            }
        }
    }
    return $nfails;
}


##
# Print version messages.
sub version
{
    print "$toolname $version\n";
}


##
# Print help message for a specific tag (or which ones are supported).
sub help_tag
{
    my ($helptag) = @_;
    my $dochelp;
    $dochelp = "$resourcedir${dirsep}docs${dirsep}PRMinXML${extsep}txt";

    open(IN, "< $dochelp") || die "Cannot find documentation file '$dochelp': $!\n";

    if (!$helptag)
    {
        print("Supported tags (with attributes, and child elements):\n");
    }

    my $show_element = 0;
    my $current_tag = undef;
    my $current_attributes = undef;
    my $current_children = undef;
    my $last = "\n";
    while (<IN>)
    {
        my $line = $_;
        if ($last eq "\n" && $_ eq "\n")
        {
            $show_element = 0;
        }
        elsif (/^Element: +(.*)\n/)
        {
            # We've found an element
            my $tag = $1;
            my $namespace = undef;
            if ($tag =~ s/ \(namespace: (.*)\)//)
            {
                $namespace = $1;
            }
            if ($tag eq $helptag)
            {
                $show_element = 1;
                print;
            }
            elsif (!$helptag)
            {
                # We're showing all elements
                $current_tag = $tag;
                $current_attributes = '<none>';
                $current_children = '<none>';
            }
        }
        elsif (/^Attributes: +(.*)\n/)
        {
            if ($show_element) {
                print;
            }
            elsif (!$helptag)
            {
                $current_attributes = $1;
            }
        }
        elsif (/^Children: +(.*)\n/)
        {
            if ($show_element) {
                print;
            }
            elsif (!$helptag)
            {
                $current_children = $1;
            }
        }
        elsif (/^ *\n/)
        {
            if ($show_element) {
                print;
            }
            elsif (!$helptag && $current_tag)
            {
                my $attr = join(', ', map { "\@$_" } split(/, */, $current_attributes));
                $attr =~ s/@<none>/<none>/;
                printf "  %-24s  %s\n", $current_tag, $attr;
                if (!$current_children)
                {
                    $current_children = '<none>';
                }
                #if ($current_children ne '<none>') {
                    printf "  %24s  %s\n", '', $current_children;
                #}
                $current_tag = undef;
            }
        }
        else
        {
            if ($show_element) {
                print;
            }
        }
        $last = $line;
    }
    close(IN);
}


##
# Print help messages.
sub help
{
    print "$toolname $version - converts structured documentation to presentation formats\n";
    print "Syntax: $toolname <options> <input-files>\n";

    my $formats = join ', ', sort keys %extensions;
    print <<EOM;
Options:

    --help, -h      This help message
    --help-indexed  Help on creating indexed collections of documents
    --help-params   Help on parameters for stylesheets
    --help-tag <tag>    Print help for a specific tag (or list the supported tags)
    --version, -V   Show version of this tool
    --catalog <version>, -C <version>
                    Select the version of the transforms to use (default $catalog_version)
    --debug, -d     Enable debug
    --lint          Lint files as well as formatting them
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
    --param <name>=<value>, -p <name>=<value>
                    Supply parameters to the stylesheet for the render format.

The 'skeleton' format outputs a skeleton document containing examples of some
of the structures used in the PRM-in-XML format:

    $tool -f skeleton -o skel.xml

The 'html' format is the most common. Usually you would use a command like
(the '-f html' is actually the default, but is used for completeness):

    $tool -f html -O outputdir mydocs.xml

The 'html+xml' format is exactly the same but copies the XML file alongside
the HTML:

    $tool -f html+xml -O outputdir mydocs.xml

The 'html5' format is similar to the 'html' format, but uses HTML 5 semantic
elements and CSS to render documents:

    $tool -f html5 -O outputdir mydocs.xml

The 'header' format outputs a C header file for the constants from the file:

    $tool -f header -O outputdir mydocs.xml

The 'command' format outputs a command line help file suitable for passing
through VTranslate:

    $tool -f command -O outputdir mydocs.xml

The 'stronghelp' format outputs a skeleton StrongHelp directory structure:

    $tool -f stronghelp -O outputdir mydocs.xml

The 'lint' format just checks that the files supplied follow the DTD defined for
the files. Whilst the HTML might be generated adequately, it is very useful
to stick to the intended definition of the format to ensure that it will
work with future iterations of the conversion.

    $tool -f lint mydocs.xml

Linting can be used as a check in addition to any of the other formatting
operations by specifying the --lint option.

The 'index' format is more complex; it can take a 'index.xml' file which
describes many documents to be included in the structured output documentation:

    $tool -f index index.xml

Use the --help-indexed option for more information on indexed documents.

Information about the PRM-in-XML format can be found in the directory:
    $resourcedir/gerph
EOM
}


##
# Print help message about indexed format.
sub help_indexed
{
    # FIXME: This could still be improved to give better examples.
    print <<EOM;
The 'index.xml' file has the following format:

----
<?xml version="1.0"?>
<index>
<dirs output="output/html"
      index="output/index"
      help="output/help"
      header="output/header"
      input="src"
      temp="tmp" />
<options
    hide-empty="no"
    include-source="no"
    make-contents="no"
    include-sections="no"
    include-sections-depth="1"
    page-format="html"
    catalog-version="103"
    page-css-base="standard"
    page-css-variant="none"
    page-css-file="none"
    index-css-base="standard"
    index-css-variant="none"
    index-css-file="none"
    />

<!-- Indexes that we want to generate -->
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

<!-- Generate an XML file containing all the referencable content -->
<make-indexdata/>

<!-- Generate a text file listing all the content files -->
<make-filelist/>

<footer>
Your Disclaimer Here.
</footer>

<!-- List of the sections and the directories that they contain, which may be nested -->
<section title="Overview" dir="overview">
    <!-- Pages to generate and list - omit 'href' for placeholders (which are hidden with hide-empty) -->
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
                    be omitted from the contents.
    include-source: 'yes' or 'no': whether source XML files will be
                    linked in the index (they will always be copied).
    make-contents:  'yes' or 'no': whether the contents with inline
                    section details will be generated. This allows
                    you to see the indexed elements inline with the
                    contents. It's not especially useful.
    include-sections: 'yes' or 'no': Whether the main contents page
                    will include the sections from the pages being
                    indexed.
    include-sections-depth: Number of nested section elements that
                    will be included on the contents page when the
                    sections are included. For example '1' would
                    list only the 'section' elements, whilst '2'
                    would list 'section' and 'subsection' elements.
    catalog-version: The version number of the catalog to use.
                    Defaults to '103'.
    page-format:    The format of the HTML content, which can be
                    either 'html' or 'html5'.
    page-css-base:  The base CSS stylesheet to use for the HTML
                    content. Defaults to 'standard'.
    page-css-variant: A list of variants to apply to the HTML
                    content. Defaults to 'none'.
    page-css-file:  A CSS file to apply to the HTML content.
                    Defaults to 'none'.
    index-css-base:  The base CSS stylesheet to use for the index
                    and contents pages. Defaults to 'standard'.
    index-css-variant: A list of variants to apply to the index
                    and contents pages. Defaults to 'no-edge-index'.
    index-css-file:  A CSS file to apply to index and contents
                    pages. Defaults to 'none'.

The 'make-index' elements describe which parts of the indexes will
be included in the output.

The 'make-filelist' element indicates that a list of the generated
HTML files is required. This will be placed in the HTML output
directory with the name 'filelist.txt'.

The 'make-indexdata' element indicates that an XML file containing
the details of all the sections and definitions which are referencable
within the generated documentation. This will be placed in the
index directory with the name 'index-data.xml'.

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

Any images supplied within the input directory will be copied into
the output, even if they are not referenced.

To convert all the files, use a command like:

    $tool -f index -L logs index.xml

To convert all the files and validate them, use a command like:

    $tool --lint -f index -L logs index.xml
EOM
}


##
# Print help message about parameters.
sub help_params
{
    print <<EOM;
The parameters supplied to each of the stylesheets are variable - not
all stylesheets support the same parameters.

EOM

    for $format (@valid_formats)
    {
        $xpath_part = "//*[local-name()='param' and namespace-uri()='${catalog_base}/prminxml-params']";
        if ($riscos)
        {
            $xpath_part = "\"$xpath_part\"";
        }
        else
        {
            # FIXME: Other shell escaping?
            $xpath_part = "\"$xpath_part\"";
        }
        $cmd = "$toollint --xpath $xpath_part ${catalog_base}/${catalog_version}/prm-$format.xsl";
        $cmd .= " > $tempbase 2>&1";
        runcommand($cmd);

        # Although it could all be extracted with xmllint, I'm going to just parse the output to make it
        # easier (and faster on RISC OS).
        open(IN, "< $tempbase") || die "Could not read information about format '$format'\n";
        print "Format: $format\n";
        my $content = '';
        while (<IN>)
        { $content .= $_; }
        my @elements = ($content =~ /(<[^>]*?:param[^>]*?>.*?<\/[^>]*?:param>)/gs);
        my $element;
        for $element (@elements)
        {
            my ($attrstr, $body) = ($element =~ /<[^>]*?:param([^>]*?)>(.*?)<\/[^>]*?:param>/s);
            my %attrs = ($attrstr =~ /([a-zA-Z0-9\-]+)="(.*?)"/g);
            printf "    %-24s : %s\n", $attrs{'name'}, $attrs{'values'};
            printf "    %-24s   Default: %s\n", '', $attrs{'default'};
            $body =~ s/\n +/\n/g;
            $body =~ s/^\n//;
            for $line (split /\n/, $body)
            {
                printf "    %-24s   %s\n", '', $line;
            }
            print "\n";
        }
    }

    unlink($tempbase);
}
