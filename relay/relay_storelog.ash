int[string] itemCount;
string[int]storeLogOld;
string[int]storeLogCum;
int cumStartCount;
int cumMeatGain;

void fullTable()
{
	write("<Table>");
	writeln("<script language=\"Javascript\" type=\"text/javascript\" src=\"sorttable.js\"></script>");
	write("<table style=\"float:left;\" cellpadding=\"13\" cellspacing=\"0\" border=\"1px\" class=\"sortable\">");
	write("<tr><th>Date</th><th>Time</th><th>Customer</th><th>Amount</th><th>Item</th><th>Total</th><th>Unit Price</th></tr>");
	foreach i in storeLogCum
	{
		matcher log = create_matcher("(\\d+\/\\d+\/\\d+) (\\d+:\\d+:\\d+) (.+) bought (\\d+) \\((.+)\\) for (\\d+) Meat.",storeLogCum[i]);
		if(find(log))
		{
			write("<tr><td>"+log.group(1)+"</td>");//Date
			write("<td>"+log.group(2)+"</td>");//Time
			write("<td>"+log.group(3)+"</td>");//Customer
			write("<td>"+log.group(4)+"</td>");//Amount
			write("<td>"+log.group(5)+"</td>");//Item
			write("<td>"+log.group(6)+"</td>");//Total
			write("<td>"+(log.group(6).to_int()/log.group(4).to_int())+"</td></tr>");
			cumMeatGain += log.group(6).to_int();
		}
	}

	write("</table>");
	write("<table style=\"float:right;text-align:center;\" cellpadding=\"3\" cellspacing=\"0\" border=\"0px\" >");
	write("<tr><th>Total Meat Gained</th></tr>");
	write("<tr><td>"+cumMeatGain.to_string("%,d")+"</td></tr>");
	write("</table>");
}

void showLogs()
{
	foreach i in storeLogCum
	{
		matcher log = create_matcher("\\d+\/\\d+\/\\d+ \\d+:\\d+:\\d+ .+ bought (\\d+) \\((.+)\\) for \\d+ Meat.",storeLogCum[i]);
		if(!find(log))
			abort("Something went Wrong 5");
		write(log.group(0)+"<br/>");
	}
}
void charTable()
{

}

void itemTable()
{
	foreach i in storeLogCum
	{
		matcher log = create_matcher("\\d+\/\\d+\/\\d+ \\d+:\\d+:\\d+ .+ bought (\\d+) \\((.+)\\) for \\d+ Meat.",storeLogCum[i]);
		if(!find(log))
			abort("Something went Wrong 4");
		itemCount[log.group(2)] = log.group(1).to_int()+itemCount[log.group(2)];
	}
	write("<table cellpadding=\"13\" cellspacing=\"0\" border=\"1px\" class=\"sortable\">");
	write("<tr><th>Item</th><th>Total Amount</th></tr>");
	foreach x,y in itemCount
	{
		write("<tr><td>"+x+"</td>");
		write("<td>"+y+"</td></tr>");
	}
	write("</table>");
}

void loadLogs()
{
	string[int]storeLog = get_shop_log();

	file_to_map("storelog_"+my_name()+".txt",storeLogOld);
	foreach i in storeLogOld
	{
		matcher log = create_matcher("(\\d+\/\\d+\/\\d+ \\d+:\\d+:\\d+ .+ bought \\d+ \\(.+\\) for \\d+ Meat.)",storeLogOld[i]);
		if(!find(log))
			abort("Something went Wrong 3");
		storeLogCum[storeLogCum.count()] = log.group(0);
		cumStartCount = storeLogCum.count();
	}
	foreach i in storeLog
	{
		matcher log = create_matcher("(\\d+): (\\d+\/\\d+\/\\d+ \\d+:\\d+:\\d+ .+ bought \\d+ \\(.+\\) for \\d+ Meat.)",storeLog[i]);
		if (!find(log))
			abort("Something went Wrong 1");
		boolean logExists = false;
		if(cumStartCount >= storeLog.count())
			foreach x in storeLogCum
			{
				matcher log2 = create_matcher("(\\d+\/\\d+\/\\d+ \\d+:\\d+:\\d+ .+ bought \\d+ \\(.+\\) for \\d+ Meat.)",storeLogCum[x]);

				if (!find(log2))
					abort("Something went Wrong 7");
				if(log.group(2) == log2.group(0))
				{
					logExists = true;
					break;
				}			
			}
		if(!logExists)
		{
			storeLogCum[storeLogCum.count()] = log.group(2);
			cumStartCount++;
		}
	}

	map_to_file(storeLogCum,"storelog_"+my_name()+".txt");
	//[22] 2: 10/14/18 03:49:00 DanceCommander6 bought 1 (stuffing fluffer) for 23000 Meat.
}

void main(){
	loadLogs();
	string[string] fields;
	boolean success;
	writeln("<center>");
	writeln("<form name='relayform' method='POST' action=''>");
	writeln("<input class=\"button\" type=\"submit\" name=\"startPage\" value='ShowLogs'/>");
	writeln("<input class=\"button\" type=\"submit\" name=\"startPage\" value='FullTable'/>");
	writeln("<input class=\"button\" type=\"submit\" name=\"startPage\" value='ItemTable'/>");
	writeln("<input class=\"button\" type=\"submit\" name=\"startPage\" value='ChartsTable'/>");
	writeln("</form></center>");
	fields = form_fields();
	success = count(fields) > 0;
	switch(fields['startPage'])
	{
		case "ShowLogs":
				showLogs();
				break;
		case "FullTable":
				fullTable();
				break;
		case "ItemTable":
				itemTable();
				break;
		//case "ChartsTable":
	//			charTable();
	//			break;
	}
	 
} 
