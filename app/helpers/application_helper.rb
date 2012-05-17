module ApplicationHelper

	def flash_notice(notice)
		html = %{}
		html << %{<div class="alert alert-success">#{notice}</div>} if notice
		html.html_safe
	end
	
	def menu_tab(active = :user, user = 0)
	  html = %{}
	  html << %{<ul class="nav nav-tabs">}
    html << %{<li #{"class='active'" if active == :user}>#{link_to t(:preferences_menu), user_path(user) }</li>}
    html << %{<li #{"class='active'" if active == :runs}>#{link_to t(:history_menu), user_runs_path(user) }</li>}
    html << %{</ul>}
    html.html_safe
	end
	
	def page_about(msg, replaces)
	  replaces.each do |key, val|
		  msg = msg.gsub("{#{key.to_s}}", val)
		end
		html = %{}
		html << %{<div class="page-info-box ">#{msg}</div>} if msg
		html.html_safe
	end
	
	def no_records(msg)
	  html = %{<div class="no-records">#{msg}</div>}
	  html.html_safe
	end
	
	def modal_dialog
    html = %{
              <div class="modal fade" id="myModalDialog">
               <div class="modal-header">
                 <button class="close" data-dismiss="modal">x</button>
                 <h3></h3>
               </div>
               <div class="modal-body"></div>
              </div>
    }
    html.html_safe    
	end
	
end
