/**
 * @file	trigger_mitsubishi.cpp
 *
 * @date Aug 5, 2014
 * @author Andrey Belomutskiy, (c) 2012-2018
 */

#include "trigger_mitsubishi.h"

void configureFordAspireTriggerShape(TriggerShape * s) {
	s->initialize(FOUR_STROKE_CAM_SENSOR, true);
	s->isSynchronizationNeeded = false;

	float x = 121.90;
	float y = 110.86;

	s->addEvent720(x + y - 180, T_SECONDARY, TV_RISE);
	s->addEvent720(x, T_SECONDARY, TV_FALL);
	s->addEvent720(x + y, T_SECONDARY, TV_RISE);
	s->addEvent720(x + 180, T_SECONDARY, TV_FALL);
	s->addEvent720(360, T_PRIMARY, TV_RISE);

	s->addEvent720(x + 180 + y, T_SECONDARY, TV_RISE);
	s->addEvent720(x + 360, T_SECONDARY, TV_FALL);
	s->addEvent720(x + 360 + y, T_SECONDARY, TV_RISE);
	s->addEvent720(x + 540, T_SECONDARY, TV_FALL);
	s->addEvent720(720, T_PRIMARY, TV_FALL);
	s->useOnlyPrimaryForSync = true;
}

/**
 * TT_MITSUBISHI = 11
 */
void initializeMitsubishi4g18(TriggerShape *s DECLARE_ENGINE_PARAMETER_SUFFIX) {
	s->initialize(FOUR_STROKE_CAM_SENSOR, true);
	s->useRiseEdge = false;

	s->setTriggerSynchronizationGap(1.6666);

	int secondaryWidth = 70;

	s->addEvent720(106.77999999999997, T_PRIMARY, TV_FALL);
	s->addEvent720(120.09999999999998, T_SECONDARY, TV_RISE);
	s->addEvent720(188.0775, T_SECONDARY, TV_FALL);
	s->addEvent720(286.33, T_PRIMARY, TV_RISE);
	s->addEvent720(298.875, T_SECONDARY, TV_RISE);
	s->addEvent720(354.91999999999996, T_PRIMARY, TV_FALL);
	s->addEvent720(366.6825, T_SECONDARY, TV_FALL);
	s->addEvent720(476.45, T_SECONDARY, TV_RISE);
	s->addEvent720(543.9749999999999, T_SECONDARY, TV_FALL);
	s->addEvent720(639.52, T_PRIMARY, TV_RISE);
	s->addEvent720(653.15, T_SECONDARY, TV_RISE);
	s->addEvent720(720.0, T_SECONDARY, TV_FALL);
	s->useOnlyPrimaryForSync = true;
}
