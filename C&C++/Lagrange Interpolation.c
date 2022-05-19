#include<stdio.h>
#include<stdlib.h>
main()
{
 int n,i,j;
 float*x,*y,*l1,s=0,x1;
 FILE*fp;
 fp=fopen("data.dat","r");
 printf("please input the amount of datas\n");
 fscanf(fp,"%d",&n); printf("n=%d\n",n);
 printf("input the interpolation data:x,y\n");
 x=(float*)calloc(n,sizeof(float));
 y=(float*)calloc(n,sizeof(float));
 l1=(float*)calloc(n,sizeof(float));
 for(i=0;i<n;i++)
   fscanf(fp,"%f,%f",&x[i],&y[i]), printf("x=%f, y=%f\n",x[i],y[i]),l1[i]=1.0;
 printf("input x\n"); fscanf(fp,"%f",&x1); fclose(fp); printf("x=%f\n",x1);
 for(i=0;i<n;i++)
 {
  for(j=0;j<n;j++)
  {
   if(i==j) 
    continue;
   else
    l1[i]=l1[i]*(x1-x[j])/(x[i]-x[j]);
  }
  s+=l1[i]*y[i];
 }
 fp=fopen("output.dat","w");
 printf("the interpolation result is %f\n",s);
 fprintf(fp,"the interpolation result is %f",s);
 fclose(fp);
}