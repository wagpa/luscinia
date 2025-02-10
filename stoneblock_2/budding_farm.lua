-- settings
motor_dir = "back"
enable_dir = "right"
axis1_redstone_dir = "left"

motor_speed = 32
axis1_steps = 6
axis1_step_length = 3
axis2_length = 15 * 10

wait_until_retry = 60
wait_until_next = 60

function harvest()
    local motor = peripheral.wrap(motor_dir)

    for step = 0, axis1_steps, 1 do
        print("Harvesting step " .. step .. " of " .. axis1_steps)

        -- move out and in
        redstone.setOutput(axis1_redstone_dir, true)
        sleep(motor.translate(axis2_length, motor_speed))
        sleep(motor.translate(-axis2_length, motor_speed))

        -- move one right
        redstone.setOutput(axis1_redstone_dir, false)
        sleep(motor.translate(axis1_step_length, motor_speed))
    end

    -- move back to start
    print("Harvested, moving back to start")
    sleep(motor.translate(-axis1_steps * axis1_step_length, motor_speed))

    motor.stop()
end

-- start next harvesting
while true do
    if redstone.getInput(enable_dir) then
        print("Enabled, starting harvest")
        harvest()
        sleep(wait_until_next)
    else
        -- check again later
        print("Disabled, trying again later")
        sleep(wait_until_retry)
    end
end