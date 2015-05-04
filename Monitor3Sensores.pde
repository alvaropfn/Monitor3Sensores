import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

Writer writer;
ArduinoCOM arduino;
final String portName = "COM7";
SimpleDateFormat sdf, hms;
final int len = 3;
boolean mudou;
int val[];

void setup()
{
	// ano/mes/dia
	sdf = new SimpleDateFormat("yyyy/MM/dd");
	// hora/minuto/milisegundo
	hms = new SimpleDateFormat("HH:mm:SS");

	writer = new Writer(this);
	arduino = new ArduinoCOM(this);

	arduino.tentarInstancia(portName);
	val = new int[3];
	for (int i : val) {i = 0;}

	size(300,150);
}

void draw()
{
	background(123);
	mudou = false;
	String saida = getHMS() + "\t";
	
	int[] temp = arduino.get3Ana();
	for (int i = 0; i < temp.length; ++i)
	{
		if(temp[i] < val[i] - 5 || temp[i] > val[i] + 5)
		{
			mudou = true;
			val[i] = temp[i];
		}

		saida +=val[i] +"\t";
	}

	if(mudou)
	{
		writer.writeAt(getSDF() +".txt", saida);
	}
	text(val[0]+", "+val[1]+", " + val[2], 10, 20);

}

public String getSDF()
{return sdf.format(new Date());}

public String getHMS()
{return hms.format(new Date());}