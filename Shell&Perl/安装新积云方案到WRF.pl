#!/usr/bin/perl
# This script is used to install the new convective scheme developed by Guangjun Zhang in WRF
# The location of original codes should be set in $CODE
# The path of WRFV3 should be set in $WRF_PATH
# Original code should have these files: module_cam_wv_saturation.F, module_cu_camzm.F, module_cu_camzm_driver.F
# Other files, including: module_cumulus_driver.F, module_first_rk_step_part1.F,
# module_physics_init.F, solve_em.F would be generated according to your WRF version.

my $CODE="/home/qianqf/scheme";
my $WRF_PATH="/home/qianqf/WRFV3";

my $DYN_EM=$WRF_PATH."/dyn_em";
my $PHYS=$WRF_PATH."/phys";

open(FILE, $DYN_EM."/solve_em.F") or die $!;
while(<FILE>) {
	push(@code, $_);

	if ($_ =~ /REAL\s*::\s*t_new/) {
		push(@code, "   REAL    ,DIMENSION(grid%sm31:grid%em31,grid%sm32:grid%em32,grid%sm33:grid%em33) :: qv_prev_my\n");
		push(@code, "   REAL    ,DIMENSION(grid%sm31:grid%em31,grid%sm32:grid%em32,grid%sm33:grid%em33) :: t_phy_prev\n");
	}
	
	if ($_ =~ /Runge_Kutta_loop:  DO rk_step = 1, rk_order/) {
		pop(@code);
		push(@code, "   qv_prev_my=moist(:,:,:,P_QV)\n");
		push(@code, "   t_phy_prev=grid%t_phy\n");
		push(@code, $_)
	}
		
	if ($_ =~ /, f_flux                           &/) {
		push(@code, "                             , qv_prev_my, t_phy_prev           &\n");
	}

	if ($_ =~ /       CALL first_rk_step_part2 \(    grid, config_flags         &/) {
		pop(@code);
		push(@code, "       qv_prev_my=moist(:,:,:,P_QV)\n");
		push(@code, "       t_phy_prev=grid%t_phy\n");
		push(@code, $_);
	}
}
close FILE;

open(mycode, ">", $CODE."/solve_em.F") or die $!;
print mycode @code;
@code=();

open(FILE, $PHYS."/module_cumulus_driver.F") or die $!;
while(<FILE>) {
	push(@code, $_);

	if ($_ =~ /!ckay for subgrid cloud/) {
		push(@code, "                     ,qv_prev_my                              &\n");
		push(@code, "                     ,t_phy_prev                              &\n");
	}

	if ($_ =~ /   LOGICAL periodic_x, periodic_y/) {
		pop(@code);
		push(@code, "   REAL    ,DIMENSION(ims:ime,kms:kme,jms:jme),INTENT(INOUT)   :: qv_prev_my\n");
		push(@code, "   REAL    ,DIMENSION(ims:ime,kms:kme,jms:jme),INTENT(INOUT)  :: t_phy_prev\n");
		push(@code, $_);
	}
	
	if ($_ =~ /               ,LENGATH2D=lengath2d/) {
		pop(@code);
		push(@code, "               ,LENGATH2D=lengath2d                                 &\n");
		push(@code, "               ,qv_prev_my=qv_prev_my, t_phy_prev=t_phy_prev)\n");
	}
}
close FILE;

open(mycode, ">", $CODE."/module_cumulus_driver.F") or die $!;
print mycode @code;
@code=();

open(FILE, $DYN_EM."/module_first_rk_step_part1.F") or die $!;
while(<FILE>) {
	push(@code, $_);
	
	if ($_ =~ /, f_flux  /) {
		push(@code, "                             , qv_prev_my, t_phy_prev           &\n");
	}

	if ($_ =~ /REAL    ,DIMENSION\(ims:ime,kms:kme,jms:jme,num_moist\),INTENT\(INOUT\)   :: moist_tend/) {
		push(@code, "    REAL    ,DIMENSION(ims:ime,kms:kme,jms:jme),INTENT(INOUT)   :: qv_prev_my\n");
		push(@code, "    REAL    ,DIMENSION(ims:ime,kms:kme,jms:jme),INTENT(INOUT)  :: t_phy_prev\n");
	}
	
	if ($_ =~ /,CLDFRA_DP=grid%cldfra_dp  ,CLDFRA_SH=grid%cldfra_sh/) {
		push(@code, "     &             ,qv_prev_my=qv_prev_my, t_phy_prev=t_phy_prev  &\n");
	}
}
close FILE;

open(mycode, ">", $CODE."/module_first_rk_step_part1.F") or die $!;
print mycode @code;
@code=();

open(FILE, $PHYS."/module_physics_init.F") or die $!;
while(<FILE>) {
	push(@code, $_);

	if ($_ =~ /INTEGER, DIMENSION\( ims:ime , jms:jme \), INTENT\(INOUT\):: LOWLYR/) {
		push(@code, "  LOGICAL restart_flag\n");
	}

	if ($_ =~ /camzmscheme/) {
		pop(@code);
		pop(@code);
		pop(@code);
		push(@code, "                      its, ite, jts, jte, kts, kte, restart_flag    \) \n");
		push(@code, "          ELSE\n");
		push(@code, "          CALL wrf_error_fatal \( 'arguments not present for calling camzmscheme' \)\n");
	}
}
close FILE;

open(mycode, ">", $CODE."/module_physics_init.F") or die $!;
print mycode @code;
@code=();

system("cp $CODE/module_physics_init.F $PHYS/");
system("cp $CODE/module_first_rk_step_part1.F $DYN_EM/");
system("cp $CODE/solve_em.F $DYN_EM/");
system("cp $CODE/module_cumulus_driver.F $PHYS/");
system("cp $CODE/module_cu_camzm.F $PHYS/");
system("cp $CODE/module_cu_camzm_driver.F $PHYS/");
system("cp $CODE/module_cam_wv_saturation.F $PHYS/");