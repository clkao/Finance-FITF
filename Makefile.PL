sub readme_from {}; sub auto_include_deps {}; sub author_tests {}; sub auto_set_repository {};
use inc::Module::Install;
name 'Finance-FITF';
all_from 'lib/Finance/FITF.pm';
readme_from 'lib/Finance/FITF.pm';
build_requires 'Test::More' => 0.88;
requires 'Class::Accessor';
requires 'Sub::Exporter';

auto_include_deps;
author_tests('xt');
auto_set_repository;
WriteAll;
