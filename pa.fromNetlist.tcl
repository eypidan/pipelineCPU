
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name OExp07-SCPUMore -dir "C:/Users/px/Desktop/OExp07_CPUMore/planAhead_run_3" -part xc7k325tffg676-2L
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/px/Desktop/OExp07_CPUMore/Top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/px/Desktop/OExp07_CPUMore} {ipcore_dir} }
add_files [list {ipcore_dir/RAM_B.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ROM_D.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Sword.ucf" [current_fileset -constrset]
add_files [list {Sword.ucf}] -fileset [get_property constrset [current_run]]
link_design
