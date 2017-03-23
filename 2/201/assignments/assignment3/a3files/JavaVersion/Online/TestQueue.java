public class TestQueue
{
  private static final int SIZE = 21;
  public static void main(String[] a)
  {
    WaitingArea w = new QueueWaitingArea();
    try
    {
      System.out.println(w.next());
    } catch (RuntimeException e)
    {
      System.out.println("<cannot remove from EMPTY data structure>");
    }

    try
    {
      System.out.println(w.display());
    } catch (RuntimeException e)
    {
      System.out.println("<cannot print EMPTY data structure>");
    }

    w.addPassenger(new Passenger("1"));
    System.out.println(w.display());

    try
    {
      System.out.println(w.next());
    } catch (RuntimeException e)
    {
      System.out.println("<cannot remove 1 element from size 1>");
    }

    try
    {
      for (int i = 1; i<=SIZE; i++)
        w.addPassenger(new Passenger(String.valueOf(i)));
    } catch (RuntimeException e)
    {
      System.out.println("<cannot add 1 of 21 elements>");
    }

    System.out.println(w.display());

    for (int i = 2; i<=SIZE; i++)
      System.out.println(w.next());

    System.out.println(w.display());
    System.out.println(w.next());

    try
    {
      System.out.println(w.next());
    } catch (RuntimeException e)
    {
      System.out.println("<cannot remove from EMPTY data structure>");
    }

    try
    {
      System.out.println(w.display());
    } catch (RuntimeException e)
    {
      System.out.println("<cannot print EMPTY data structure>");
    }

  }
}
