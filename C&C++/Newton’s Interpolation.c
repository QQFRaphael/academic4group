#include<stdio.h>
#include<stdlib.h>
#include<string.h>
main()
{
	int n,i,col,row,j;
	float*x,*y,**table;
	float s,x1,l;
	FILE* fp;
	fp=fopen("data.dat","r");
	printf("input the amounts of datas:");
	fscanf(fp,"%d",&n);
	printf("%d\n",n);
	x=(float*)calloc(n,sizeof(float));
	y=(float*)calloc(n,sizeof(float));
	table=(float**)calloc(n,sizeof(float*));
	for(i=0;i<n;i++)
		table[i]=(float*)calloc(n,sizeof(float));
	printf("input the interpolation datas x,y:\n");
	for(i=0;i<n;i++)
		for(j=0;j<n;j++)
			table[i][j]=0;
	for(i=0;i<n;i++)
		fscanf(fp,"%f,%f",&x[i],&y[i]),printf("x=%f,y=%f\n",x[i],y[i]);
    for(i=0;i<n;i++)
        table[i][0]=y[i];
	printf("input x:");
    fscanf(fp,"%f\n",&x1);
	printf("%f\n",x1);
	for(col=1;col<n;col++)
		for(row=col;row<n;row++)
			table[row][col]=(table[row][col-1]-table[row-1][col-1])/(x[row]-x[row-col]);
	s=table[0][0];
    for(i=1;i<n;i++)
	{   l=1;
		for(j=0;j<i;j++)
			l*=(x1-x[j]);
		l*=table[i][i];
		s+=l;
	}
	fclose(fp); fp=fopen("output.dat","w");
	fprintf(fp,"the interpolation result is: %f",s);
	printf("the interpolation result is: %f\n",s);
	fclose(fp);
}