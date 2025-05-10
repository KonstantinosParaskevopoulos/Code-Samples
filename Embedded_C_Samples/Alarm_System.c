/*
 * EXC04.c
 *
 * Created: 16/5/2023 1:31:14 πμ
 * Author : konstantinos
 */ 

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#define delay 10		//Καθυστέρηση Συναγερμού
#define limit 10		//Resolution ADC0
#define PERIOD_VALUE (0x007F)		//Περίοδος = 416
#define DUTY_CYCLE_VALUE (0x003F)	//Duty Cycle = 50%

/************************************************************************/
/* LED0 =>	LED σειρήνας												*/
/* LED1 =>	LED	ένδειξης λειτουργίας συναγερμού							*/
/* LED2 =>	LED του ADC													*/
/************************************************************************/

//Global Μεταβλητές

int buttonsPressed = 0;	//Συνολικός Αριθμός κουμπιών που έχουν πατηθεί, αυξάνεται μόνο αν ο κωδικός είναι σωστός μέχρι το αντίστοιχο κάθε φορά σημείο
int correctCode[4];		//Πίνακας που περιέχει τον σωστό κωδικό και με τον οποίο θα συγκρίνεται κάθε φορά ψηφίο-ψηφίο ο εισαγόμενος κωδικός
int codeInput[4];		//Πίνακας Εισαγόμενου Κωδικού
int mistakes = 0;		//Αριθμός Λανθασμένων Εισαγωγών
int Alarm=0;			//Μεταβλητή Κατάστασης Συναγερμού
int ADCenabled=0;			//Μεταβλητή Ενεργοποίησης ADC0
int number_5 = 0b00100000;
int number_6 = 0b01000000;

void initButton_INT();		/*Αρχικοποίηση INT από Button*/
void initADC_INT();			/*Αρχικοποίηση INT από ADC σε Free Running Mode*/
void initTCB0_Timer_INT();	/*Αρχικοποίηση INT από Timer*/
void initTCA_PWM_INT();		/*Ενεργοποίηση INT για PWM*/
void enable_TCB0();			/*Ενεργοποίηση Timer TCB0*/
void disableTCB0();			/*Απενεργοποίηση Timer TCB0*/
void enable_ADC0();			/*Ενεργοποίηση ADC0*/
void enableTCA0_PWM();		/*Ενεργοποίηση Timer TCA0 για PWM (Σειρήνα)*/
void disableTCA0_PWM();		/*Ενεργοποίηση Timer TCA0 για PWM (Σειρήνα)*/
void enableAlarm();			/*Ενεργοποίηση Συναγερμού*/
void disableAlarm();		/*Απενεργοποίηση Συναγερμού*/
void disableADC0();			/*Απενεργοποίηση ADC0*/
int checkInput();			/*Έλεγχος Εισαγόμενου κωδικού*/


int main(void)
{
	correctCode[0]=5;
	correctCode[1]=6;
	correctCode[2]=5;
	correctCode[3]=6;
	PORTD.DIR |= 0b00000111; //PIN0, PIN1, PIN2 is output
	PORTD.OUT |= 0b00000001; //Αρχικοποίηση Σειρήνας-Φωτός
    PORTD.OUT |= 0b00000010; //Ο Συναγερμός είναι απενεργοποιημένος
	PORTD.OUT |= 0b00000100; //Το Φως του ADC0 είναι απενεργοποιημένο
	initButton_INT();
	initADC_INT();
	initTCB0_Timer_INT();
	initTCA_PWM_INT();
    sei(); //Enable interrupts
    while (1) 
    {
		;
    }
}

/************************************************************************/
/*                             Functions                                */
/************************************************************************/

void initButton_INT(){
	//pullup enable and Interrupt enabled with sense on both edges
	PORTF.PIN5CTRL |= PORT_PULLUPEN_bm | PORT_ISC_BOTHEDGES_gc;
	PORTF.PIN6CTRL |= PORT_PULLUPEN_bm | PORT_ISC_BOTHEDGES_gc;
}


void initADC_INT(){

	ADC0.CTRLA |= ADC_RESSEL_10BIT_gc; // 10-bit resolution
	ADC0.CTRLA |= ADC_ENABLE_bm; // Enable ADC
	ADC0.MUXPOS |= ADC_MUXPOS_AIN7_gc; // Select ADC channel
	ADC0.DBGCTRL |= ADC_DBGRUN_bm; // Enable debug mode
	// Window Comparator Mode
	ADC0.CTRLA |= ADC_FREERUN_bm; // Free-running mode enabled
	ADC0.WINLT |= limit; // threshold
	ADC0.INTCTRL |= ADC_WCMP_bm; // enable interrupt for WCM
	ADC0.CTRLE |= ADC_WINCM0_bm; // interrupt when RESULT < WINLT
}

void enable_ADC0(){
	ADC0.COMMAND |= ADC_STCONV_bm;
}

void disableADC0(){
	ADC0.COMMAND &= ~(ADC_STCONV_bm);
}

void initTCB0_Timer_INT(){
	TCB0.CCMP= delay;	//Εισαγωγή χρονικής καθυστέρησης του Συναγερμού
	TCB0.CNT = 0; //Clear
	TCB0.CTRLB = 0;        	//1 in Bit 0 to enable
	/* Configure TCB in Periodic Timeout mode */
	TCB0.CTRLB = TCB_CCMPEN_bm;
	/* Enable Capture */
	TCB0.INTCTRL = TCB_CAPT_bm;
}


void enable_TCB0(){
	//Enable TCB0 and set CLK_PER divider to 2 (CLK_PER/2) 1.65 MHz
	TCB0.CTRLA = TCB_CLKSEL_CLKDIV2_gc | TCB_ENABLE_bm;
}

void disableTCB0(){
	TCB0.CTRLA &= ~(TCB_ENABLE_bm);
}

void initTCA_PWM_INT(){
	//prescaler=1024
	TCA0.SINGLE.CTRLA=TCA_SINGLE_CLKSEL_DIV1024_gc;
	TCA0.SINGLE.PER = PERIOD_VALUE; //select the resolution
	TCA0.SINGLE.CMP0 = DUTY_CYCLE_VALUE; //select the duty cycle
	//select Single_Slope_PWM
	TCA0.SINGLE.CTRLB |= TCA_SINGLE_WGMODE_SINGLESLOPE_gc;
	//enable interrupt Overflow
	TCA0.SINGLE.INTCTRL = TCA_SINGLE_OVF_bm;
	//enable interrupt COMP0
	TCA0.SINGLE.INTCTRL |= TCA_SINGLE_CMP0_bm;
	
}
void enableTCA0_PWM(){
	TCA0.SINGLE.CTRLA |= TCA_SINGLE_ENABLE_bm; //Enable
}
void disableTCA0_PWM(){
	TCA0.SINGLE.CTRLA &= ~(TCA_SINGLE_ENABLE_bm); /* stop timer */
}

int checkInput(){
	if(codeInput[buttonsPressed]!=correctCode[buttonsPressed]&&mistakes<3){
		if(Alarm==1){mistakes++;}//Εαν ο Συναγερμός είναι ενεργοποιημένος μετράμε τα λάθη
		buttonsPressed=0;//Επαναφορά στην κατάσταση στην οποία ο Χρήστης δεν έχει πατήσει κανένα κουμπί
		return 0;
	}
	else if(codeInput[buttonsPressed]!=correctCode[buttonsPressed]&&mistakes>=3){
		if(Alarm==1){enableTCA0_PWM();}//Ενεργοποίηση Σειρήνας εάν ο Συναγερμός ήταν Ενεργοποιημένος
			return 0;
	}
	else if(codeInput[buttonsPressed]==correctCode[buttonsPressed]){
		return 1;
	}
	return 0;
}

void enableAlarm(){
	PORTD.OUTCLR = 0b00000010; //Ο Συναγερμός είναι ενεργοποιημένος
	Alarm=1;
	enable_TCB0();	//Ενεργοποίηση Χρονικού Διαστήματος Απομάκρυνσης
}
void disableAlarm(){
	PORTD.OUT |= 0b00000010; //Ο Συναγερμός είναι απενεργοποιημένος
	Alarm=0;
	disableTCB0();	//Απενεργοποίηση Timer
	disableADC0();	//Απενεργοποίηση ADC0 
}



/************************************************************************/
/*                             Interrupts                               */
/************************************************************************/
/*Interrupts PWM Σειρήνας*/
ISR(TCA0_OVF_vect){
	//clear the interrupt flag
	int intflags = TCA0.SINGLE.INTFLAGS;
	TCA0.SINGLE.INTFLAGS = intflags;
	PORTD.OUT |= PIN0_bm; //PIN is off
	cli();
}

ISR(TCA0_CMP0_vect){
	//clear the interrupt flag
	int intflags = TCA0.SINGLE.INTFLAGS;
	TCA0.SINGLE.INTFLAGS = intflags;
	PORTD.OUTCLR |= PIN0_bm; //PIN is on
	cli();
}
/*Interrupt TCB0 Χρονικού περιθωρίου απομάκρυνσης*/
ISR(TCB0_INT_vect){  //Τέλος Χρονικού διαστήματος απομάκρυνσης-Ενεργοποίηση ADC0
	
	int intflags0 = TCB0.INTFLAGS;
	TCB0.INTFLAGS=intflags0;
	disableTCB0();
	if(ADCenabled==1){
		enableTCA0_PWM();
		ADCenabled=0;//Επαναφορά τιμής ADCenabled
	}
	else{
		enable_ADC0();
	}
	
	
	cli();
}
/*Interrupt ADC0 Αισθητήρα Εγγύτητας*/
ISR(ADC0_WCOMP_vect){
	//clear the flags of the ADC
	ADCenabled=1;
	int intflags = ADC0.INTFLAGS;
	ADC0.INTFLAGS = intflags;
	PORTD.OUTCLR |= PIN2_bm; //Ανάβει το φως του ADC0
	enable_TCB0();
	enableTCA0_PWM();//Ενεργοποίηση σειρήνας όσο ο ADC είναι ενεργοποιημένος
	cli();
}

ISR(PORTF_PORT_vect){
	//clear the interrupt flag
	
	int check=0;
	//
	int pressedNumber_5 = PORTF.INTFLAGS & number_5;	//Εαν έχει πατηθεί το κουμπί 5 το αποτέλεσμα θα είναι 0b00100000
	int pressedNumber_6 = PORTF.INTFLAGS & number_6;	//Εαν έχει πατηθεί το κουμπί 6 το αποτέλεσμα θα είναι 0b01000000
	
	if(pressedNumber_5==number_5){
		codeInput[buttonsPressed]=5;
		check = checkInput();//Έλεγχος εισόδου
		if(check==1){			//Αν η είσοδος είναι σωστή
			buttonsPressed++;	//Αύξηση του συνολικού αριθμού κουμπιών που έχουν 
			PORTF.INTFLAGS=pressedNumber_5; //Clear
		}
	}
	if(pressedNumber_6==number_6){
		codeInput[buttonsPressed]=6;
		check = checkInput();
		if(check==1){
			buttonsPressed++;
			PORTF.INTFLAGS=pressedNumber_6; //Clear
		}
	}
	if(buttonsPressed==4){//Το buttonsPressed θα είναι 4 μόνο υπό την προυπόθεση ότι έχει εισαχθεί ο σωστός συνδυασμός
		if(Alarm==1){
			disableAlarm();//Απενεργοποίηση Συναγερμού αν ήταν Ενεργοποιημένος
			disableTCA0_PWM();//Απενεργοποίηση Σειρήνας
		}
		else{enableAlarm();}//Ενεργοποίηση Συναγερμού αν ήταν Απενεργοποιημένος
	}
	cli();
}

