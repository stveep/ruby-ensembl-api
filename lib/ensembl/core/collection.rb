#
# = ensembl/core/collection.rb
#
# Copyright::   Copyright (C) 2009 Francesco Strozzi <francesco.strozzi@gmail.com>
#                           
# License::     The Ruby License
#
# @author Francesco Strozzi

module Ensembl
  nil
  module Core
    # Class to describe and handle multi-species databases
    #
    class Collection
      # Method to check if the current core database is a multi-species db.
      # Returns a boolean value.
      #
      # @return [Boolean] True if current db is multi-species db; otherwise false.
      def self.check()
        host,user,password,db_name,port = Ensembl::Core::DBConnection.get_info
        if db_name =~/(\w+)_collection_core_.*/ 
          return true
        end
        return false
      end

      # Returns an array with all the Species present in a collection database.
      # 
      # @return [Array<String>] Array containing species names in colleciton
      def self.species()
      # syntax for older activerecord versions
      # return Meta.find_by(meta_key: "species.db_name").map{|m| m.meta_value}
        return Meta.where(meta_key: "species.db_name").map{|m| m.meta_value}
      end
      
      # Returns the species_id of a particular species present in the database.
      # 
      # @param [String] species Name of species
      # @return [Integer] Species ID in the database.
      def self.get_species_id(species)
        species = species.downcase
        meta = Meta.find_by_sql("SELECT * FROM meta WHERE LOWER(meta_value) = '#{species}'")[0]
        if meta.nil?
          return nil
        else
          return meta.species_id
        end
      end
      
      # Returns an array with all the coord_system_id associated with a particular species and a table_name.
      # Used inside Slice#method_missing to filter the coord_system_id using a particular species_id.
      #
      # @param [String] table_name Table name
      # @param [Integer] species_id ID of species in the database
      # @return [Array<Integer>] Array containing coord_system IDs.
      def self.find_all_coord_by_table_name(table_name,species_id)
        all_ids = CoordSystem.where(species_id: species_id)
       # return MetaCoord.find_by_id_and_table_name(all_ids,table_name)
        return MetaCoord.where(coord_system_id: all_ids, table_name: table_name)
      end
      
    end
    
    
  end
end
