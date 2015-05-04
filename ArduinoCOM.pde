import processing.serial.*;
import cc.arduino.*;

public class ArduinoCOM 
{

	private PApplet dad;
	private Arduino arduino;
	private boolean conectado;
	private String COM;
	
	private final int qtd_saidas_dig = 6;
	private final int qtd_entradas_ana = 16;
	private final int qtd_entradas_dig = 46;

	private int[] entrada_dig;
	private int[] entrada_ana;
	
	private int[] saida_dig;

	private int[] dados_dig;
	private int[] dados_ana;

	//construtor
	public ArduinoCOM (PApplet dad)
	{
		this.dad = dad;
		this.conectado = false;
		setup();
	}

	//tenta inicializar a instancia de um arduino
	public boolean tentarInstancia(String serial)
	{
		try
		{
			arduino = new Arduino(dad, serial, 57600);
			definirModosPortas();
			println("conexao com: " + serial + " bem sucedida");
			this.conectado = true;
			
		}
		catch (Exception e)
		{
			println(e.getMessage());
			this.conectado = false;
		}
		finally
		{
			return this.conectado;
		}
	}

	//define quais sao os pinos das saidas digitais
	private void definirSaidasDigitais()
	{
		int ajuste = 2;//valor da primeira porta valida
		saida_dig = new int[qtd_saidas_dig];
		for (int i = 0 ; i < qtd_saidas_dig ; i++)
		{
			saida_dig[i] = i + ajuste;
		}
	}
	
	//define quais sao os pinos das entradas digitais
	private void definirEntradasDigitais()
	{
		int ajuste = 8;//valor da primeira porta valida
		entrada_dig = new int[qtd_entradas_dig];
		for (int i = 0 ; i < qtd_entradas_dig ; i++)
		{
			entrada_dig[i] = i + ajuste;
		}
		dados_dig = new int[qtd_entradas_dig];
	}
	
	//define quais sao os pinos das entradas analogicas
	private void definirEntradasAnalogicas()
	{
		entrada_ana = new int[qtd_entradas_ana];
		for (int i = 0 ; i < qtd_entradas_ana ; i++)
		{
			entrada_ana[i] = i;
		}
		dados_ana = new int[qtd_entradas_ana];
	}

	//seta os vetores que guardam o estado dos dados como 0
	private void resetarDados()
	{
		for (int dig : dados_dig){dig = 0;}
		for (int ana : dados_ana){ana = 0;}
	}

	//define tamanhos dos vetores das portas e seus pinos
	private void setup()
	{
		definirSaidasDigitais();
		definirEntradasDigitais();
		definirEntradasAnalogicas();
		resetarDados();
	}

	//define os modos das portas de entrada e saida no arduino
	private void definirModosPortas()
	{
		for (int sdg : saida_dig) {arduino.pinMode(sdg,Arduino.OUTPUT);}//necessario
		for (int ana : entrada_ana) {arduino.pinMode(ana,Arduino.INPUT);}//necessario
		for (int dig : entrada_dig) {arduino.pinMode(dig,Arduino.INPUT);}//redundancia
	}

	//realiza a leitura de todas as portas digitais como se fossem analogicas
	public void leituraInternaAnaComoDig()
	{
		//não le nada em caso de falha na conexão
		if(!conectado)return;

		int len = qtd_entradas_ana;
		for (int i = 0; i < len; ++i)
		{
			int temp = arduino.analogRead(entrada_dig[i]);
			temp = temp > 300 ? 1 : 0;
			dados_ana[i] += temp;
		}
	}

	//realiza a leitura de todas as portas analogicas
	public void leituraInternaAna()
	{
		//não le nada em caso de falha na conexão
		if(!conectado)return;

		int len = qtd_entradas_ana;
		for (int i = 0; i < len; ++i)
		{
			int temp = arduino.analogRead(entrada_ana[i]);
			dados_ana[i] += temp;
		}
	}

	//raliza a leitura de todas as ortas digitais
	public void leituraInternaDig()
	{
		//não le nada em caso de falha na conexão
		if(!conectado)return;

		int len = qtd_entradas_dig;
		for (int i = 0; i < len; ++i)
		{
			int temp = arduino.digitalRead(entrada_dig[i]);
			dados_ana[i] += temp;
		}
	}

	public boolean conectado()
	{return this.conectado;}

	//retorna um array com todos os analogicos salvos
	int[] getDadosAna()
	{return this.dados_ana;}

	//retorna um array com todos os digitais salvos
	int[] getDadosDig()
	{return this.dados_dig;}

	//retorna um array com todos os pinos setaos como saidas digitais
	public int[] getSaidasDig()
	{return this.saida_dig;}

	//retorna um array com todos os pinos setaos como entradas analogicas
	public int[] getEntradasAna()
	{return this.entrada_ana;}

	//retorna um array com todos os pinos setaos como entradas digitais
	public int[] getEntradasDig()
	{return this.entrada_dig;}

	public int[] get3Ana()
	{
		if(!conectado) return null;

		int len = 3;
		int[] temp = new int[len];
		for (int i = 0; i < len; ++i)
		{
			temp[i] = arduino.analogRead(entrada_ana[i]);
		}
		return temp;
	}

}

