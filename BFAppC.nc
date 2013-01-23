configuration BFAppC
{
}
implementation 
{
	components MainC, BFC, SHA1C;

	BFC -> MainC.Boot;
	BFC -> SHA1C.SHA1;
	
}
