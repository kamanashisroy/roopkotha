using aroop;
using shotodol;
using roopkotha;

/** \addtogroup velapp
 *  @{
 */
internal class roopkotha.app.VelaTest : UnitTest {
  etxt tname;
  public VelaTest() {
    tname = etxt.from_static("Vela Test");
  }
  public override aroop_hash getHash() {
    return tname.getStringHash();
  }
  public override void getName(etxt*name) {
    name.dup_etxt(&tname);
  }
  public override int test() throws UnitTestError {
    print("VelaTest:~~~~TODO fill me\n");
    return 0;
  }
}
/** @} */

