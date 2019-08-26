#===============================================================================
# ▼ Script Information
#===============================================================================
# Script   : Extended_Shops
# Author   : CaRa_CrAzY Petrassi
# Level    : Normal
# Requires : n/a
# Version  : 1.00
# Date     : 2019.06.14
#
#===============================================================================
# ▼ Description
#===============================================================================
# This script enables : 
# • Shops to run out of stock.
# • Shops to randomize their stock either by quantity or by item type.
#
#===============================================================================
($imported ||= {})[:CaRaCrAzY_ExtendedShops] = 1.00

#===============================================================================
# ** CaRaCrAzY
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CaRaCrAzY
  class Shop
    attr_accessor :name, :item_pool, :actual_items
    def initialize
      @name         = "Shop"
      @item_pool    = {}
      @actual_items = {}
    end
    def retrieve_pool
    end
  end
end