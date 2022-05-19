#include "Solver.h"
#include "Params.h"
#include "Data_Structure.h"
#include <iostream>
#include <math.h>
#include <fstream>

namespace Shallow_Water_Model {

Grid (*inGrid)[ny][nx] = new Grid[noutput][ny][nx];
StaticGrid (*inStatic)[nx] = new StaticGrid[ny][nx];
float (*uh)[nx] = new float [ny][nx];
float (*vh)[nx] = new float [ny][nx];
float (*h_mid_xt)[nx-1] = new float [ny][nx-1];
float (*h_mid_yt)[nx] = new float [ny-1][nx];
float (*ux)[nx] = new float [ny][nx];
float (*uy)[nx] = new float [ny][nx];
float (*vx)[nx] = new float [ny][nx];
float (*vy)[nx] = new float [ny][nx];
float (*uh_mid_xt)[nx-1] = new float [ny][nx-1];
float (*uh_mid_yt)[nx] = new float [ny-1][nx];
float (*vh_mid_xt)[nx-1] = new float [ny][nx-1];
float (*vh_mid_yt)[nx] = new float [ny-1][nx];
float (*ux_mid_xt)[nx-1] = new float [ny][nx-1];
float (*uy_mid_yt)[nx] = new float [ny-1][nx];
float (*vx_mid_xt)[nx-1] = new float [ny][nx-1];
float (*vy_mid_yt)[nx] = new float [ny-1][nx];
float (*unew)[nx] = new float [ny][nx];
float (*vnew)[nx] = new float [ny][nx];
float (*hnew)[nx] = new float [ny][nx];
float (*uhnew)[nx] = new float [ny][nx];
float (*vhnew)[nx] = new float [ny][nx];
float (*u)[nx] = new float [ny][nx];
float (*v)[nx] = new float [ny][nx];
float (*h)[nx] = new float [ny][nx];
float (*f)[nx] = new float [ny][nx];
float (*H)[nx] = new float [ny][nx];
float (*sx)[nx] = new float [ny][nx];
float (*sy)[nx] = new float [ny][nx];
int *time = new int [noutput];

void Lax_Wendroff_Solver::scheme() {
	for(int ii=0; ii<ny; ii++) {
		for(int jj=0; jj<nx; jj++) {
			uh[ii][jj] = u[ii][jj]*h[ii][jj];
			vh[ii][jj] = v[ii][jj]*h[ii][jj];
			ux[ii][jj] = uh[ii][jj]*u[ii][jj]+0.5*g*h[ii][jj]*h[ii][jj];
			uy[ii][jj] = uh[ii][jj]*v[ii][jj];
			vx[ii][jj] = uy[ii][jj];
			vy[ii][jj] = vh[ii][jj]*v[ii][jj]+0.5*g*h[ii][jj]*h[ii][jj];
		}
	}

	for(int ii=0; ii<ny; ii++) {
		for(int jj=0; jj<nx-1; jj++) {
			h_mid_xt[ii][jj] = 0.5*(h[ii][jj+1]+h[ii][jj])-(0.5*delta_t/delta_x)*(uh[ii][jj+1]-uh[ii][jj]);
			uh_mid_xt[ii][jj] = 0.5*(uh[ii][jj+1]+uh[ii][jj])-(0.5*delta_t/delta_x)*(ux[ii][jj+1]-ux[ii][jj]);
			vh_mid_xt[ii][jj] = 0.5*(vh[ii][jj+1]+vh[ii][jj])-(0.5*delta_t/delta_x)*(vx[ii][jj+1]-vx[ii][jj]);
			ux_mid_xt[ii][jj] = uh_mid_xt[ii][jj]*uh_mid_xt[ii][jj]/h_mid_xt[ii][jj]+0.5*g*h_mid_xt[ii][jj]*h_mid_xt[ii][jj];
			vx_mid_xt[ii][jj] = uh_mid_xt[ii][jj]*vh_mid_xt[ii][jj]/h_mid_xt[ii][jj];
		}
	}

	for(int ii=0; ii<ny-1; ii++) {
		for(int jj=0; jj<nx; jj++) {
			h_mid_yt[ii][jj] = 0.5*(h[ii+1][jj]+h[ii][jj])-(0.5*delta_t/delta_y)*(vh[ii+1][jj]-vh[ii][jj]);
			uh_mid_yt[ii][jj] = 0.5*(uh[ii+1][jj]+uh[ii][jj])-(0.5*delta_t/delta_y)*(uy[ii+1][jj]-uy[ii][jj]);
			vh_mid_yt[ii][jj] = 0.5*(vh[ii+1][jj]+vh[ii][jj])-(0.5*delta_t/delta_y)*(vy[ii+1][jj]-vy[ii][jj]);
			uy_mid_yt[ii][jj] = uh_mid_yt[ii][jj]*vh_mid_yt[ii][jj]/h_mid_yt[ii][jj];
			vy_mid_yt[ii][jj] = vh_mid_yt[ii][jj]*vh_mid_yt[ii][jj]/h_mid_yt[ii][jj]+0.5*g*h_mid_yt[ii][jj]*h_mid_yt[ii][jj];
		}
	}

	for(int ii=1; ii<ny-1; ii++) {
		for(int jj=1; jj<nx-1; jj++) {
			sx[ii][jj] = f[ii][jj]*v[ii][jj]-(g/(2.*delta_x))*(H[ii+1][jj]-H[ii-1][jj]);
			sy[ii][jj] = -f[ii][jj]*u[ii][jj]-(g/(2.*delta_y))*(H[ii][jj+1]-H[ii][jj-1]);
			hnew[ii][jj] = h[ii][jj]-(delta_t/delta_x)*(uh_mid_xt[ii][jj]-uh_mid_xt[ii][jj-1])-(delta_t/delta_y)*(vh_mid_yt[ii][jj]-vh_mid_yt[ii-1][jj]);
			uhnew[ii][jj] = uh[ii][jj]-(delta_t/delta_x)*(ux_mid_xt[ii][jj]-ux_mid_xt[ii][jj-1])-(delta_t/delta_y)*(uy_mid_yt[ii][jj]-uy_mid_yt[ii-1][jj])+delta_t*sx[ii][jj]*0.5*(h[ii][jj]+hnew[ii][jj]);
			vhnew[ii][jj] = vh[ii][jj]-(delta_t/delta_x)*(vx_mid_xt[ii][jj]-vx_mid_xt[ii][jj-1])-(delta_t/delta_y)*(vy_mid_yt[ii][jj]-vy_mid_yt[ii-1][jj])+delta_t*sy[ii][jj]*0.5*(h[ii][jj]+hnew[ii][jj]);
			unew[ii][jj] = uhnew[ii][jj]/hnew[ii][jj];
			vnew[ii][jj] = vhnew[ii][jj]/hnew[ii][jj];
		}
	}
};

void Lax_Wendroff_Solver::set_boundary() {
	for(int ii=1; ii<ny-1; ii++) {
		for(int jj=1; jj<nx-1; jj++) {
			u[ii][jj] = unew[ii][jj];
			v[ii][jj] = vnew[ii][jj];
			h[ii][jj] = hnew[ii][jj];
		}
		u[ii][0] = unew[ii][nx-2];
		u[ii][nx-1] = unew[ii][1];
		v[ii][0] = vnew[ii][nx-2];
		v[ii][nx-1] = vnew[ii][1];
		h[ii][0] = hnew[ii][nx-2];
		h[ii][nx-1] = hnew[ii][1];
	}

	for(int jj=1; jj<nx-1; jj++) {
		u[0][jj] = unew[0][jj];
		u[ny-1][jj] = unew[ny-1][jj];
		v[0][jj] = 0.0;
		v[ny-1][jj] = 0.0;
	}
};

float Lax_Wendroff_Solver::find_max_wind_speed(float uwnd[ny][nx], float vwnd[ny][nx]) {
	float spd = 0;
	float max_spd = 0;

	for(int ii=0; ii<ny; ii++) {
		for(int jj=0; jj<nx; jj++) {
			spd = sqrt(uwnd[ii][jj]*uwnd[ii][jj]+vwnd[ii][jj]*vwnd[ii][jj]);
			if(max_spd<spd) {
				max_spd = spd;
			};
		}
	}

	return max_spd;
};

void Lax_Wendroff_Solver::save() {
	
	std::ofstream outfile;
	
	outfile.open("./out_data/u_out.txt");
	for (int ii = 0; ii<noutput; ii++) {
		for (int jj = 0; jj<ny; jj++) {
			for (int kk = 0; kk<nx; kk++) {
				outfile << inGrid[ii][jj][kk].u << std::endl;
			}
		}
	}
	outfile.close();

	outfile.open("./out_data/v_out.txt");
	for (int ii = 0; ii<noutput; ii++) {
		for (int jj = 0; jj<ny; jj++) {
			for (int kk = 0; kk<nx; kk++) {
				outfile << inGrid[ii][jj][kk].v << std::endl;
			}
		}
	}
	outfile.close();

        outfile.open("./out_data/h_out.txt");
        for (int ii = 0; ii<noutput; ii++) {
                for (int jj = 0; jj<ny; jj++) {
                        for (int kk = 0; kk<nx; kk++) {
                                outfile << inGrid[ii][jj][kk].h << std::endl;
                        }   
                }   
        }   
        outfile.close();

        outfile.open("./out_data/t_out.txt");
        for (int ii = 0; ii<noutput; ii++) {
		outfile << time[ii] << std::endl;
        }
        outfile.close();
};

void Lax_Wendroff_Solver::initialize() {
        std::ifstream infile;

        infile.open("./init_data/u.txt");
        for (int jj = 0; jj<nx; jj++) {
                for (int kk = 0; kk<ny; kk++) {
                        infile >> inGrid[0][kk][jj].u;
                }   
        }   
        infile.close();

        infile.open("./init_data/v.txt");
        for (int jj = 0; jj<nx; jj++) {
                for (int kk = 0; kk<ny; kk++) {
                        infile >> inGrid[0][kk][jj].v;
                }   
        }   
        infile.close();

        infile.open("./init_data/h.txt");
        for (int jj = 0; jj<nx; jj++) {
                for (int kk = 0; kk<ny; kk++) {
                        infile >> inGrid[0][kk][jj].h;
                }
        }
        infile.close();

        infile.open("./init_data/topo.txt");
        for (int jj = 0; jj<nx; jj++) {
                for (int kk = 0; kk<ny; kk++) {
                        infile >> inStatic[kk][jj].H;
                }
        }
        infile.close();

        infile.open("./init_data/f.txt");
        for (int jj = 0; jj<nx; jj++) {
                for (int kk = 0; kk<ny; kk++) {
                        infile >> inStatic[kk][jj].f;
                }
        }
        infile.close();
};

void Lax_Wendroff_Solver::run() {
	int idx_out = 0;
	float max_speed = 0;

	initialize();

	for(int ii=0; ii<ny; ii++) {
		for(int jj=0; jj<nx; jj++) {
			u[ii][jj] = inGrid[0][ii][jj].u;
			v[ii][jj] = inGrid[0][ii][jj].v;
			h[ii][jj] = inGrid[0][ii][jj].h;
			H[ii][jj] = inStatic[ii][jj].H;
			f[ii][jj] = inStatic[ii][jj].f;
		}
	}

	for (int nn=0; nn<nt; nn++) {
		if (nn % static_cast< int >(floor(output_interval * 60.0 / delta_t)) == 0) {
			max_speed = find_max_wind_speed(u, v);
			for(int ii=0; ii<ny; ii++) {
				for(int jj=0; jj<nx; jj++) {
					inGrid[idx_out][ii][jj].u = u[ii][jj];
					inGrid[idx_out][ii][jj].v = v[ii][jj];
					inGrid[idx_out][ii][jj].h = h[ii][jj];
				}
			}
			printf("Time = %f hours / %f hours, max speed = %f \n",(nn)*delta_t/3600., forecast_days*24, max_speed);
			time[idx_out] = nn * delta_t;
			idx_out+=1;
		}

		scheme();

		set_boundary();
	}

	save();
};

}
