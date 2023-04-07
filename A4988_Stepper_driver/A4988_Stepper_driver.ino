#include "A4988_config.h"
#include "A4988_interface.h"
void A4988_Init()
{
  pinMode(Direction_pin, OUTPUT);
  pinMode(Step_Pin, OUTPUT);
}

void A4988_VoidStepRotation(char No_steps,char Direction)
{
  digitalWrite(Direction_pin, Direction);
  for(int i=0; i < No_steps; i++)
    {
      digitalWrite(Step_Pin, HIGH);
      delayMicroseconds(A4988_speed); //Speed may be changed by adding new parameter
      digitalWrite(Step_Pin, LOW);
      delayMicroseconds(A4988_speed); //Speed may be changed by adding new parameter
    }
}

void A4988_VoidRevRotation(char No_revs,char Direction)
{
  digitalWrite(Direction_pin, Direction);
  for(int i=0; i < (No_revs * A4988_no_steps_per_rev); i++)
    {
      digitalWrite(Step_Pin, HIGH);
      delayMicroseconds(A4988_speed); //Speed may be changed by adding new parameter
      digitalWrite(Step_Pin, LOW);
      delayMicroseconds(A4988_speed); //Speed may be changed by adding new parameter
    }
}


void setup() 
{
  /*A4988_Init();
  A4988_VoidRevRotation(3 , ClockWise);
  delay(1000);
  A4988_VoidStepRotation(6 ,CounterClockWise);*/
}

void loop() 
{
  // put your main code here, to run repeatedly:

}