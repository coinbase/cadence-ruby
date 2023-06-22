#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << '.'
$LOAD_PATH << File.join(__dir__, '../lib')
$LOAD_PATH << File.join(__dir__, '../ext')

require 'oj'

GC.stress = true

Oj.mimic_JSON

Oj.add_to_json(Hash)
pp JSON('{ "a": 1, "b": 2 }', :object_class => JSON::GenericObject)
