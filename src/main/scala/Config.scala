package wav.d2d

import wav.common._
import wav.wlink._

import chisel3._
import chisel3.util._
import chisel3.experimental._
import chisel3.stage.ChiselStage

import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._


class WithWlinkWaviousD2DOneAXIConfig(
  //numTxLanes      : Int = 1,
  //numRxLanes      : Int = 1,
  axi1Size        : BigInt = 0x100000,
  axi1BeatBytes   : Int = 4,
  axi1IdBits      : Int = 4
) extends Config((site, here, up) => {

  case WlinkParamsKey => WlinkParams(
    phyParams = WlinkPHYWaviousD2DParams(
      numTxLanes = 8,
      numRxLanes = 8,
    ),
    axiParams = Some(Seq(
      WlinkAxiParams(
        base                = 0x0,
        size                = axi1Size,
        beatBytes           = axi1BeatBytes,
        idBits              = axi1IdBits,
        name                = "axi1",
        startingLongDataId  = 0x80,
        startingShortDataId = 0x4),
      )),
  )
})

class Wlink8LaneWaviousD2DOneAXIConfig extends Config(
  new WithWlinkWaviousD2DOneAXIConfig() ++
  new BaseWlinkConfig
)
