# Scrumbler - Add scrum functionality to any Redmine installation
# Copyright (C) 2011 256Mb Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.dirname(__FILE__) + '/../test_helper'

class ScrumblerSettingsControllerTest < ActionController::TestCase
  fixtures :projects, 
    :scrumbler_project_settings,
    :users,
    :roles,
    :members,
    :member_roles,
    :trackers,
    :projects_trackers,
    :enabled_modules
  
  def setup
    #    Infect project with scrumbler module
    @project = projects(:projects_001)
    @project.enable_module!(:redmine_scrumbler)
    
    #    admin user
    @manager = users(:users_002)
    
    #     Infect manager role with scrumbler permission
    @manager_role = roles(:roles_001)
    @manager_role.permissions << :scrumbler
    @manager_role.permissions << :scrumbler_settings
    @manager_role.save
    
    
    User.current = nil
  end
  
  test "should update trackers by admin" do 
    new_tracker_setting = Hash.new()
    new_tracker_setting["1"] = {"position"=>1, "id"=>1, "color"=>"faa", "use"=>true}
    new_tracker_setting["1"] = {"position"=>3, "id"=>2, "color"=>"faa", "use"=>true}
    new_tracker_setting["3"] = {"position"=>2, "id"=>3, "color"=>"faa", "use"=>true}
    
    
    post(:update_trackers, {:project_id => @project.id, :scrumbler_project_setting => {:trackers => new_tracker_setting}}, {:user_id => @manager.id})  
    assert_redirected_to project_scrumbler_settings_url(@project, :trackers)
    assert_equal "Successful update.", flash[:notice]
    assert_equal new_tracker_setting, ScrumblerProjectSetting.first.trackers
  end

end
  