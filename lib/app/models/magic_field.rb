class MagicField < ActiveRecord::Base
  has_many :magic_field_relationships, :dependent => :destroy
  has_many :owners, :through => :magic_field_relationships, :as => :owner
  has_many :magic_attributes, :dependent => :destroy

  validates_presence_of :name, :datatype, :pretty_name_cn, :type_scoped
  validates_format_of :name, :with => /\A[a-z][a-z0-9_]+\z/

  before_save :set_pretty_name

  def self.datatypes
    ["string", "check_box_boolean", "date", "datetime", "integer", "float", "boolean"]
  end

  def type_cast(value)
    begin
      case datatype.to_sym
        when :float
          value.to_f
        when :boolean
          (value.to_s == 'true') ? true : false
        when :string
          value
        when :check_box_boolean
          (value.to_int == 1) ? true : false
        when :date
          Date.parse(value)
        when :datetime
          Time.parse(value)
        when :integer
          value.to_int
      else
        value
      end
    rescue
      value
    end
  end

  # Display a nicer (possibly user-defined) name for the column or use a fancified default.
  def set_pretty_name
    self.pretty_name = name.humanize if  pretty_name.blank?
  end

end
