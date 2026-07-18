using System;
using System.Runtime.InteropServices;
using UnityEngine.XR.iOS;

internal static class Program
{
    private const int ExpectedAssertionCount = 11;

    private static int failures;
    private static int executed;

    private static void Expect(bool condition, string message)
    {
        executed += 1;
        if (condition)
        {
            return;
        }

        failures += 1;
        Console.Error.WriteLine("FAIL: " + message);
    }

    private static int Main()
    {
        Expect(Marshal.SizeOf<ARPoint>() == 16, "ARPoint native layout");
        Expect(Marshal.SizeOf<ARSize>() == 16, "ARSize native layout");
        Expect(Marshal.SizeOf<ARRect>() == 32, "ARRect native layout");
        Expect(Marshal.SizeOf<ARLightEstimate>() == 8, "ARLightEstimate native layout");
        Expect(Marshal.SizeOf<ARTextureHandles>() == IntPtr.Size * 2, "ARTextureHandles native layout");

        Expect(Enum.GetUnderlyingType(typeof(ARErrorCode)) == typeof(long), "ARErrorCode backing type");
        Expect((long)ARErrorCode.ARErrorCodeWorldTrackingFailed == 200, "world-tracking error code");
        Expect(Enum.GetUnderlyingType(typeof(ARHitTestResultType)) == typeof(long), "hit-test backing type");
        Expect(
            (ARHitTestResultType.ARHitTestResultTypeFeaturePoint |
             ARHitTestResultType.ARHitTestResultTypeExistingPlaneUsingExtent) ==
            (ARHitTestResultType)17,
            "hit-test flags remain composable");
        Expect((int)ARTrackingState.ARTrackingStateNormal == 2, "normal tracking state value");
        Expect(
            (int)ARTrackingStateReason.ARTrackingStateReasonInsufficientFeatures == 3,
            "insufficient-features reason value");

        Console.WriteLine("assertions executed: " + executed);

        if (executed < ExpectedAssertionCount)
        {
            Console.Error.WriteLine(
                "FAIL: assertion floor breached; expected at least " + ExpectedAssertionCount +
                " executed assertions but observed " + executed);
            return 1;
        }

        if (failures != 0)
        {
            Console.Error.WriteLine("failing assertions: " + failures);
            return 1;
        }

        Console.WriteLine("ARKit native-interface production contracts passed");
        return 0;
    }
}
