-- settings
motor_dir = "back"
enable_dir = "right"
axis1_redstone_dir = "left"

axis1_length = 30
axis1_step_length = 3
axis2_length = 15

wait_until_retry = 60
wait_until_next = 60

axis1_pos = 0

function harvest()
    local motor = peripheral.wrap(motor_dir)

    axis1_steps = axis1_length / axis1_step_length
    for step = 0, axis1_steps, 1 do
        print("Harvesting step " .. step .. " of " .. axis1_steps)

        -- move out and in
        redstone.setOutput(axis1_redstone_dir, true)
        sleep(motor.translate(axis2_length, 32))
        sleep(motor.translate(-axis2_length, 32))
        sleep(1)

        -- move one left
        redstone.setOutput(axis1_redstone_dir, false)
        sleep(motor.translate(axis1_step_length, 32))
        axis1_pos = axis1_pos + 1
        sleep(1)
    end

    -- move back to start
    print("Harvested, moving back to start")
    sleep(motor.translate(-axis1_length, 32))

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