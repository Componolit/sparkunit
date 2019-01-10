**THIS CODE BASE IS NOT MAINTAINED ANYMORE AND KEPT FOR HISTORICAL REFERENCE
ONLY. THE LIBRARY WAS DEVELOPED IN SPARK 2005, WHEREAS OTHER TEST FRAMEWORKS
LIKE AUnit CAN BE USED WITH THE CURRENT SPARK 2014 LANGUAGE VERSION.**





====================================================================
SPARKUnit - A unit test framework for the SPARK programming language
====================================================================

*Beware of bugs in the above code; I have only proved it correct, not tried it.*
(Donald E. Knuth)

----------------------------------------------

SPARKUnit is a unit test framework for the SPARK programming language [1]_. It
enables the developer to create unit tests in SPARK which can be analysed by
the SPARK Examiner. This allows for testing of SPARK operations with
preconditions and flow analysis of test cases.

It can handle an arbitrary (but fixed) amount of test suites and test cases and
produce a report in text format. Furthermore, it supports benchmarks, a special
kind of test case. With benchmarks the execution time of a test case can be
compared with a reference measurement. The performance is output as a
percentage of its reference value in the test report.

The main design goal of SPARKUnit was to make unit testing in SPARK as simple
and flexible as possible and to avoid introduction of additional verification
overhead. Consequently, no preconditions must be established to use SPARKUnit
primitives and some errors (like out-of-memory) will not be detected before
running the test harness. For the SPARKUnit library itself "only" absence of
run-time errors has been proven.

Copyright, Warranty and Licensing
=================================

| Copyright (C) 2010, Alexander Senier

| All rights reserved.

SPARKUnit is released under the simplified BSD license::

   Redistribution  and  use  in  source  and  binary  forms,  with  or  without
   modification, are permitted provided that the following conditions are met:

      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.

      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.

      * Neither the name of the  nor the names of its contributors may be used
        to endorse or promote products derived from this software without
        specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE  COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY  EXPRESS OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED  TO, THE
   IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR  A PARTICULAR PURPOSE
   ARE  DISCLAIMED. IN  NO EVENT  SHALL  THE COPYRIGHT  HOLDER OR  CONTRIBUTORS
   BE  LIABLE FOR  ANY  DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR
   CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED  TO,  PROCUREMENT  OF
   SUBSTITUTE GOODS  OR SERVICES; LOSS  OF USE,  DATA, OR PROFITS;  OR BUSINESS
   INTERRUPTION)  HOWEVER CAUSED  AND ON  ANY THEORY  OF LIABILITY,  WHETHER IN
   CONTRACT,  STRICT LIABILITY,  OR  TORT (INCLUDING  NEGLIGENCE OR  OTHERWISE)
   ARISING IN ANY WAY  OUT OF THE USE OF THIS SOFTWARE, EVEN  IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

Features
========

Version 0.1.0 of SPARKUnit has the folloing features:

- Support for test suites and test cases
- Performance comparison through benchmark tests
- Arbitrary (but fixed) number of suites, cases and benchmarks
- Test report in text format

The list of changes in SPARKUnit is available in the CHANGES_ file and the list
of planned enhancements in the TODO_ file.

Download
========

Release version
---------------

The current release version of SPARKUnit is available at
http://senier.net/SPARKUnit/SPARKUnit-0.1.0.tgz

An API documentation of the current release version can be found at
http://senier.net/SPARKUnit/sparkunit.html

Development version
-------------------

The current development version of SPARKUnit is available through its GIT
[2]_ repository: ``git://git.codelabs.ch/sparkunit.git``

A browsable version of the repository is also available here:
http://git.codelabs.ch/?p=sparkunit.git

Please send bug reports and comments to Alexander Senier <mail@senier.net>.

Building and installing
=======================

Required tools
--------------

To build and prove SPARKUnit, the following tools are required:

- GCC or GNAT Pro
- SPARK 9 (SPARK Pro or SPARK GPL)
- GNU make, version >= 3.81
- AdaBrowse (for building the API documentation, tested with 4.0.3)
- Docutils (for building the documentation, tested with 0.6)

The primary development environment of SPARKUnit is Ubuntu 10.04 (x86_64).
Though the source and project files should be system independent, the Makefiles
assume a UNIXish system (cygwin seems to work).  Tools like ``mkdir``,
``uname``, ``tail`` and ``install`` must be present in the systems search path.

Build process
-------------

To build SPARKUnit, change to the source directory and type::

$ make

You can install the library to <destination>, by typing::

$ make DESTDIR=<destination> install

Configuration is performed automatically by the top-level ``Makefile`` and can be
altered by passing the following variables to ``make``:

+------------------+----------------------------------------------------------------------+
|variable          | description                                                          |
+==================+======================================================================+
|``NO_TESTS``      | Disable tests step.                                                  |
+------------------+----------------------------------------------------------------------+
|``NO_PROOF``      | Disable proof step.                                                  |
+------------------+----------------------------------------------------------------------+
|``NO_APIDOC``     | Disable generation of API documentation.                             |
+------------------+----------------------------------------------------------------------+
|``TARGET_CFG``    | Target system configuration.                                         |
+------------------+----------------------------------------------------------------------+
|``SPARK_DIR``     | Base directory of the SPARK installation.                            |
+------------------+----------------------------------------------------------------------+
|``DESTDIR``       | Installation base directory.                                         |
+------------------+----------------------------------------------------------------------+

Using SPARKUnit
===============

Examples for using SPARKUnit can be found in the ``tests`` subdirectory.

Extending SPARKUnit
===================

You are welcome to extend SPARKUnit according to the terms of the simplified
BSD license referenced above. Please obey the following rules when contributing
changes back to the project:

- Make sure no undischarged VCs remain.
- Make sure the code compiles
- Try to stay consistent with the current style of the source.
- Create your patches using git-format-patch.

.. [1] SPARK - http://www.altran-praxis.com/spark.aspx
.. [2] GIT - the fast version control system, http://git-scm.com
.. _CHANGES: CHANGES.html
.. _TODO: TODO.html
