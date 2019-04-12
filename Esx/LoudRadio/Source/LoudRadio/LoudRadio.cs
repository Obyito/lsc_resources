using System.Collections.Generic;
using System.Threading.Tasks;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;

namespace LoudRadio
{
    public class LoudRadio : BaseScript
    {
        public LoudRadio()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            var ply = PlayerPedId();
            var veh = GetVehiclePedIsIn(ply, true);
            var isEngineOn = GetIsVehicleEngineRunning(veh);

            if (IsPedInAnyVehicle(ply, false) && IsControlPressed(1, 75))
            {
                await Delay(250);

                if (IsPedInAnyVehicle(ply, false))
                {
                    if (isEngineOn)
                    {
                        SetVehicleEngineOn(veh, true, true, true);
                        SetVehicleRadioEnabled(veh, true);
                        SetVehicleRadioLoud(veh, true);
                    }
                }
            }
        }
    }
}
