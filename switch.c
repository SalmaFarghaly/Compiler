 switch (x)
  {
  case 1:
    x = 10; break;
 case 2:
    x = 20; break;

  default:
    break;
  }

// 1 == x 1 t1 
// 2 cmp t1 true - 
// 3 jne l1
// 4 = 10 t
// 5 = t x 
// 7 l1 ::
// 8 == x 2 t1
// 9 cmp t1 true
// 10 jne l2
// 11 20 = t
// 12 t = x
// 13 l2 ::
