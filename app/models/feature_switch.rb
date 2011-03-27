class FeatureSwitch < ActiveRecord::Base
   
  validates :name, :presence => true, :uniqueness => true
 
  def self.enabled? feature_name
    find_or_create(feature_name).enabled 
  end
  
  def self.enable feature_name
    find_or_create(feature_name).update_attribute(:enabled, true)
  end
  
  def self.disable feature_name
    find_or_create(feature_name).update_attribute(:enabled, false)
  end
  
  def self.find_or_create feature_name
    find_by_name(feature_name) || create(:name => feature_name)
  end
  
end
