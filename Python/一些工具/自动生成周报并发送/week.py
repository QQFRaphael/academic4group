#encoding:UTF-8
from weekly_report_function import auto_weekly_report
import time

myname = "Qifeng Qian"

myprogress = "In this week, I read several papers to find more cases. \
Finally, I decide to simulate the convection happened in the north China at 2013 as the representation of cases of \
north China. Another case, happed in the east of China is also take into consideration as the representation \
of cases of east China. Now there are three cases happened in the north, south and east of China. If \
all the simulation using the improved scheme show an strengthen of the cold pool, the improvement is indeed \
effective. This is suggested by all the professors in the proposal defense."

nextweek = "I would go forward to the WRF simulations of the two cases. If all the simulation could be finished in \
the following week, I would also check the simulation results."

url_base = "http://journals.ametsoc.org/doi/abs/10.1175/"
journal = "MWR"
paper_url = url_base + journal + "-D-15-0442.1"

my_weekly_report = auto_weekly_report(paper_url, "./qifeng_qian"+time.strftime('%Y-%m-%d',time.localtime(time.time()))+".docx")

abstract = my_weekly_report.get_abstract()

docx=my_weekly_report.write_to_docx(myname, myprogress, abstract, nextweek)

my_weekly_report.send_to_prof("zhaozongci@mail.tsinghua.edu.cn;yongluo@mail.tsinghua.edu.cn;jbh@mail.tsinghua.edu.cn")
