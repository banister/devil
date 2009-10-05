#!/usr/bin/env ruby

require 'mkmf'

have_library("IL", "ilInit");
have_library("ILU", "iluInit");
have_library("ILUT", "ilutInit");

create_makefile('devil')
