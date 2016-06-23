#
# = test/unit/release_79/core/test_gene.rb - Unit test for Ensembl::Core
#
# Copyright::   Copyright (C) 2009 Francesco Strozzi <francesco.strozzi@gmail.com>, Steve Pettitt <spettitt@gmail.com>
#
# License::     Ruby's
#
# $Id:

require 'pathname'
libpath = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 4, 'lib')).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)

require 'test/unit'
require 'ensembl'

include Ensembl::Core

class TestGene < Test::Unit::TestCase
  
  def setup
    DBConnection.connect('homo_sapiens', 79)
  end
  
  def teardown
    DBConnection.remove_connection
  end
  
  def test_stable_id
    ids = %w(ENSG00000243485 ENSG00000237613 ENSG00000240361 ENSG00000186092)
    genes = Gene.find_by_stable_id(ids)
    assert_equal(4,genes.size)
    assert_equal("ENSG00000186092",genes[0].stable_id)
    assert_equal(69091,genes[0].seq_region_start)
    assert_equal(70008,genes[0].seq_region_end)
    assert_equal("olfactory receptor, family 4, subfamily F, member 5 [Source:HGNC Symbol;Acc:HGNC:14825]",genes[0].description)
    
    gene = Gene.find_by_stable_id("ENSG00000186092")
    assert_equal("ENSG00000186092",gene.stable_id)
    assert_equal(69091,gene.seq_region_start)
    assert_equal(70008,gene.seq_region_end)
    assert_equal("olfactory receptor, family 4, subfamily F, member 5 [Source:HGNC Symbol;Acc:HGNC:14825]",genes[0].description)
  end
  
  
end
