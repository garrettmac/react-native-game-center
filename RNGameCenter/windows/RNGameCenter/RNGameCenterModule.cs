using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Game.Center.RNGameCenter
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNGameCenterModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNGameCenterModule"/>.
        /// </summary>
        internal RNGameCenterModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNGameCenter";
            }
        }
    }
}
