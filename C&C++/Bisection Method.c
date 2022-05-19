#include<stdio.h>
#include<math.h>
double precision=0.000001;

/*已知函数，形式为f(x)=0*/
float func(float x)
{
	float s;
	s=(x-2)*(x-4);
	return s;
}

/*预先估计零点区间，区间内只有一个零点*/
float bisec(float a,float b)
{
	float fa,fb,fc,c;
	c=(a+b)/2;
	fa=func(a), fb=func(b), fc=func(c);
	while(fabs(fc)>precision)
	{
		if(fa*fc<0)
		  b=c, c=(a+b)/2, fb=func(b), fc=func(c);
		else
		  a=c, c=(a+b)/2, fa=func(a), fc=func(c);
	}
	return c;
}

main()
{
	float m,n,s;
	FILE*fp;
	fp=fopen("data.dat","r");
	fscanf(fp,"%f,%f",&m,&n);
	s=bisec(m,n);
	printf("between %f and %f the zero point is %f\n",m,n,s);
	fclose(fp);
	fp=fopen("output.dat","w");
	fprintf(fp,"between %f and %f the zero point is %f\n",m,n,s);
	fclose(fp);
}
