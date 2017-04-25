@isTest
public class EEC_PaginatedSelectListTest {
    
    @isTest
    static void testGetSubList(){
        EEC_PaginatedSelectList ps = new EEC_PaginatedSelectList();
        for(integer i = 0; i < 1001; i++){
            ps.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        
        SelectOption so = ps.get(1);
        System.assertEquals('1', so.getValue());
        ps.remove(1);
        System.assertEquals(1000, ps.getSize());
        ps.getSelectList();
        ps.clear();
    }
    @isTest
    static void testSubList(){
        EEC_PaginatedSelectList ps = new EEC_PaginatedSelectList();
        for(integer i = 0; i < 1001; i++){
            ps.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        
        List<SelectOption> so = ps.getSubList(1, 50);
        System.assertEquals(50, so.size());
        List<SelectOption> sop0 = ps.get0();
        List<SelectOption> sop1 = ps.get1();        
        List<SelectOption> sop2 = ps.get2();        
        List<SelectOption> sop3 = ps.get3();        
        List<SelectOption> sop4 = ps.get4();   
        List<SelectOption> sop5 = ps.get5();         
    }

}