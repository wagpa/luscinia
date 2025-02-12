-- settings
motor_dir = "back"
enable_dir = "top"
axis1_redstone_dir = "left"
axis2_redstone_dir = "right"

motor_speed = 32
axis1_steps = 6
axis1_step_length = -3
axis2_length = 16

wait_until_retry = 60
wait_until_next = 60 * 10

function sign(x)
    return (x < 0 and -1) or 1
end

function harvest()
    local motor = peripheral.wrap(motor_dir)

    for step = 0, axis1_steps, 1 do
        print("Harvesting step " .. step .. " of " .. axis1_steps)

        -- move out and in
        -- move out until redstone signal as it might take longer for breaking the blocks
        redstone.setOutput(axis1_redstone_dir, true)
        while not redstone.getInput(axis2_redstone_dir) do
            sleep(motor.translate(sign(axis2_length) * 1, motor_speed))
        end
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